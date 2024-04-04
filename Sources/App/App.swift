import Vapor

public struct App {
    var app: Application

    public init() {
        app = Application()

        app.routes.get("") { (request) in
            return "hello"
        }

        app.asyncCommands.use(Cmd(), as: "cmd")
    }

    public func main() async throws {
        try await app.execute()
        app.shutdown()
    }

    public static func main() async throws {
        let app = App()
        try await app.main()
    }
}
