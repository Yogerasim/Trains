import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierResponseType = Components.Schemas.CarrierResponse

protocol CarrierInfoServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierResponseType
}

final class CarrierInfoService: CarrierInfoServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client = APIConfig.client, apikey: String = APIConfig.apiKey) {
        self.client = client
        self.apikey = apikey
    }

    func getCarrierInfo(code: String) async throws -> CarrierResponseType {
        let query = Operations.getCarrierInfo.Input.Query(apikey: apikey, code: code, system: nil, format: nil, lang: nil)
        let response = try await client.getCarrierInfo(query: query)
        return try response.ok.body.json
    }

    func testFetchCarrier(code: String = "TK") {
        Task {
            do {
                print("Fetching carrier info for code: \(code)")
                let resp = try await getCarrierInfo(code: code)
                print("Carriers count: \(resp.carriers?.count ?? 0)")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
