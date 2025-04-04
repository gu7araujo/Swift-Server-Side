//
//  ContentView.swift
//  SwiftClient
//
//  Created by Gustavo Araujo Santos on 4/1/25.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView: View {
    
    let client: Client
    @State private var text = "🫥"
    
    init() {
        self.client = Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport())
    }
    
    var body: some View {
        VStack {
            Text(text).font(.system(size: 100))
            Button("Get emojis!") {
                Task { try await updateEmoji() }
            }
            .padding()
            Button("Get greet!") {
                Task { try await updateGreet() }
            }
        }
        .padding()
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
            case .undocumented(statusCode: let statusCode, _):
                text = "🤖"
            }
        } catch { 
            text = "🤖"
        }
    }
    
    func updateGreet() async throws {
        do { 
            let response = try await client.postGreet(.init(body: .json(.init(name: "Gustavo", lastname: "Santos"))))
            
            switch response { 
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let content):
                    text = content.message ?? "🤖"
                }
            case .undocumented(statusCode: let statusCode, _):
                text = "🤖"
            }
        } catch { 
            text = "🤖"
        }
    }
}

#Preview {
    ContentView()
}
