import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias CopyrightResponseType = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> CopyrightResponseType
}

final class CopyrightService: CopyrightServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client = APIConfig.client, apikey: String = APIConfig.apiKey) {
        self.client = client
        self.apikey = apikey
    }

    func getCopyright() async throws -> CopyrightResponseType {
        let query = Operations.getCopyright.Input.Query(apikey: apikey, format: nil)
        let response = try await client.getCopyright(query: query)
        return try response.ok.body.json
    }

    func testFetchCopyright() {
        Task {
            do {
                print("Fetching copyright...")
                let resp = try await getCopyright()
                if let text = resp.copyright?.text {
                    print("Copyright text: \(text)")
                } else {
                    print("No copyright text")
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
