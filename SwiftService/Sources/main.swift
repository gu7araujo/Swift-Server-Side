import Foundation
import Vapor
import OpenAPIRuntime
import OpenAPIVapor

// Define a type that conforms to the generated protocol.
struct GreetingServiceAPIImpl: APIProtocol {
    func getEmoji(_ input: Operations.GetEmoji.Input) async throws -> Operations.GetEmoji.Output {
        let emojis = "👋👍👏🙏🤙🤘"
        let emoji = String(emojis.randomElement()!)
        return .ok(Operations.GetEmoji.Output.Ok(body: .json(emoji)))
    }
}

// Create your Vapor application.
let app = try await Vapor.Application.make()

// Create a VaporTransport using your application.
let transport = VaporTransport(routesBuilder: app)

// Create an instance of your handler type that conforms the generated protocol
// defining your service API.
let handler = GreetingServiceAPIImpl()

// Call the generated function on your implementation to add its request
// handlers to the app.
try handler.registerHandlers(on: transport, serverURL: Servers.Server1.url())

// Start the app as you would normally.
try await app.execute()
