//
//  ContentView.swift
//  SwiftClient
//
//  Created by Gustavo Araujo Santos on 4/1/25.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView<C: APIProtocol>: View {
    
    let client: C
    @State private var text = "🫥"
    
    init(client: C) { 
        self.client = client
    }
    
    init() where C == Client {
        self.client = Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport())
    }
    
    var body: some View {
        VStack {
            Text(text)
                .font(.system(size: 100))
                .padding()
            Button("Get emojis!") {
                Task { try await updateEmoji() }
            }
            .padding()
            Button("Get greet!") {
                Task { try await updateGreet() }
            }
        }
        .buttonStyle(.borderedProminent)
    }
    
    func updateEmoji() async throws {
        do { 
            let response = try await client.getEmoji(Operations.GetEmoji.Input())
            
            switch response {
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let content):
                    text = content
                }
            case .undocumented(_, _):
                text = "❌"
            }
        } catch { 
            text = "❌"
        }
    }
    
    func updateGreet() async throws {
        do { 
            let response = try await client.postGreet(.init(body: .json(.init(name: "Gustavo", lastname: "Santos"))))
            
            switch response { 
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let content):
                    text = content.message ?? "❌"
                }
            case .undocumented(_, _):
                text = "❌"
            }
        } catch { 
            text = "❌"
        }
    }
}

struct MockClient: APIProtocol {
    func postGreet(_ input: Operations.PostGreet.Input) async throws -> Operations.PostGreet.Output {
        .ok(.init(body: .json(.init(message: "Greeting Mocked!", person: .init(name: "mock", lastname: "mock again")))))
    }
    
    func getEmoji(_ input: Operations.GetEmoji.Input) async throws -> Operations.GetEmoji.Output {
        .ok(.init(body: .json("🤖")))
    }    
}

#Preview {
    ContentView(client: MockClient())
}
