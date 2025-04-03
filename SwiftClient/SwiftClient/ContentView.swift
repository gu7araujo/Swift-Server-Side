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
    @State private var emoji = "🫥"
    
    init() {
        self.client = Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport())
    }
    
    var body: some View {
        VStack {
            Text(emoji).font(.system(size: 100))
            Button("Get emojis!") {
                Task { try? await updateEmoji() }
            }
        }
        .padding()
        .buttonStyle(.borderedProminent)
    }
    
    func updateEmoji() async throws {
        let response = try await client.getEmoji(Operations.GetEmoji.Input())
        
        switch response {
        case let .ok(okResponse):
            switch okResponse.body {
            case .json(let content):
                emoji = content
            }
        case .undocumented(statusCode: let statusCode, _):
            emoji = "🤖"
        }
    }
}

#Preview {
    ContentView()
}
