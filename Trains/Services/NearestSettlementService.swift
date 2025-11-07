import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestSettlementResponse = Components.Schemas.NearestSettlementResponse

protocol NearestSettlementServiceProtocol {
    func getNearestSettlement(lat: Double, lng: Double, distance: Int?) async throws -> NearestSettlementResponse
}

final class NearestSettlementService: NearestSettlementServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client = ApiConfig.client, apikey: String = ApiConfig.apiKey) {
        self.client = client
        self.apikey = apikey
    }

    func getNearestSettlement(lat: Double, lng: Double, distance: Int? = nil) async throws -> NearestSettlementResponse {
        let query = Operations.getNearestSettlement.Input.Query(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance != nil ? Double(distance!) : nil,
            format: nil,
            lang: nil
        )

        let response = try await client.getNearestSettlement(query: query)
        return try response.ok.body.json
    }

    func testFetchNearestSettlement() {
        Task {
            do {
                print("Fetching nearest settlement...")
                let resp = try await getNearestSettlement(lat: 50.440046, lng: 40.4882367, distance: 50)
                print("Nearest settlement: \(resp.title ?? "nil") (\(resp.code ?? "nil"))")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
