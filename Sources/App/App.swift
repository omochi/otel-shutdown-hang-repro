import Vapor
import Logging
import ServiceLifecycle
import Tracing
import OTel
import OTLPGRPC

public struct App {
    private static func makeTracer() async throws -> any Service {
        let environment = OTelEnvironment.detected()

        var resourceDetection = OTelResourceDetection(
            detectors: [
                OTelProcessResourceDetector(),
                OTelEnvironmentResourceDetector(environment: environment)
            ]
        )

        let serviceName = "otel-app"

        resourceDetection.detectors.append(
            .manual(
                OTelResource(attributes: [
                    "service.name": .string(serviceName)
                ])
            )
        )

        let resource = await resourceDetection.resource(environment: environment)
        let exporter = try OTLPGRPCSpanExporter(
            configuration: .init(environment: environment),
            group: .singletonMultiThreadedEventLoopGroup,
            requestLogger: Logger(label: "SpanExporter"),
            backgroundActivityLogger: Logger(label: "SpanExporterBG")
        )

        let idGenerator = OTelRandomIDGenerator()

        let sampler = OTelConstantSampler(isOn: true)

        let propagator = OTelW3CPropagator()

        let processor = OTelBatchSpanProcessor(
            exporter: exporter,
            configuration: .init(
                environment: environment
            )
        )

        let tracer = OTelTracer(
            idGenerator: idGenerator,
            sampler: sampler,
            propagator: propagator,
            processor: processor,
            environment: environment,
            resource: resource
        )

        InstrumentationSystem.bootstrap(tracer)

        return tracer
    }

    public static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let tracer = try await makeTracer()

        let app = Application(env)

        let serviceGroup = ServiceGroup(services: [tracer], logger: app.logger)

        let serviceGroupTask = Task {
            try await serviceGroup.run()
        }

        app.routes.get("") { (request) in
            withSpan("GET /") { (span) in
                return "hello"
            }
        }

        app.asyncCommands.use(Cmd(), as: "cmd")

        try await app.execute()
        app.shutdown()

        await serviceGroup.triggerGracefulShutdown()

        try await serviceGroupTask.result.get()
    }
}
