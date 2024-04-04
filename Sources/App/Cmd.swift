import Vapor

struct Cmd: AsyncCommand {
    struct Signature: CommandSignature {}
    var help: String { "help" }
    func run(using context: CommandContext, signature: Signature) async throws {
        print("hello cmd")
    }
}
