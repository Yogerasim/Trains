//
//  ContentView.swift
//  Trains
//
//  Created by Филипп Герасимов on 05/11/25.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            // Instantiate the OpenAPI client and service, then call the test method.
            let client = Client(
                serverURL: (try? Servers.Server1.url()) ?? URL(string: "https://example.com")!,
                transport: URLSessionTransport()
            )
            let service = NearestStationsService(client: client, apikey: "358e8b9d-a92c-4b0b-a840-9ca909f976d8")
            service.testFetchStations()
        }
    }
}

#Preview {
    ContentView()
}
