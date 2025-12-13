import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum APIConfig {
    static let apiKey: String = "358e8b9d-a92c-4b0b-a840-9ca909f976d8"
    static let runTests: Bool = true

    static func makeClient() -> Client {
        //LoggingURLProtocol.registerIfNeeded()

        return Client(
            serverURL: try! Servers.Server1.url(),
            transport: HTMLJSONTransport()
            
        )
    }

    static let client: Client = makeClient()
}
