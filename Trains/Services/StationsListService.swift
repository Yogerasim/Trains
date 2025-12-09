import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsListResponseType = Components.Schemas.StationsListResponse

protocol StationsListServiceProtocol {
    func getStationsList() async throws -> StationsListResponseType
}

final class StationsListService {
    private let client: Client
    private let apiKey: String

    init(client: Client = APIConfig.client, apikey: String = APIConfig.apiKey) {
        self.client = client
        self.apiKey = apikey
    }

    func getStationsList() async throws -> StationsListResponseType {
        let query = Operations.getStationsList.Input.Query(
            apikey: apiKey,
            format: nil,
            lang: nil
        )
        let response = try await client.getStationsList(query: query)
        return try response.ok.body.json
    }

    func testFetchStationsList(limitToOneCountry: Bool = false) {
        Task {
            do {
                let res = try await getStationsList()
                if limitToOneCountry {
                    if let first = res.countries?.first {
                        print("StationsList first country: \(first.title ?? "nil")")
                    } else {
                        print("StationsList has no countries")
                    }
                } else {
                    print("StationsList loaded: \(res)")
                }
            } catch {
                print("StationsList error: \(error)")
            }
        }
    }
}
