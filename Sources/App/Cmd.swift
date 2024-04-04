import Vapor
import Tracing

struct Cmd: AsyncCommand {
    struct Signature: CommandSignature {}
    var help: String { "help" }
    func run(using context: CommandContext, signature: Signature) async throws {
        withSpan("hello cmd") { (span) in
            print("hello cmd")
        }
    }
}
