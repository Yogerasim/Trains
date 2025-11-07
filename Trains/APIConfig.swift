import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum APIConfig {
    static let apiKey = "358e8b9d-a92c-4b0b-a840-9ca909f976d8"
    static let runTests = true
    static let client: Client = {
        return Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )
    }()
}
// ApiConfig.swift
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum ApiConfig {
    static var apiKey: String = "358e8b9d-a92c-4b0b-a840-9ca909f976d8" // поменяй на свой
    static var serverURL: URL = (try? Servers.Server1.url()) ?? URL(string: "https://api.rasp.yandex-net.ru")!

    // Shared Client to avoid recreating sessions and to reduce chance of burst calls.
    static let client: Client = {
        let transport = URLSessionTransport()
        return Client(serverURL: serverURL, transport: transport)
    }()
}
