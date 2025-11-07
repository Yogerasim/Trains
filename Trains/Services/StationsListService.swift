import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsListResponseType = Components.Schemas.StationsListResponse

protocol StationsListServiceProtocol {
    func getStationsList() async throws -> StationsListResponseType
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client = APIConfig.client, apikey: String = APIConfig.apiKey) {
        self.client = client
        self.apikey = apikey
    }

    func getStationsList() async throws -> StationsListResponseType {
        let query = Operations.getStationsList.Input.Query(
            apikey: apikey,
            format: nil,
            lang: nil
        )

        let response = try await client.getStationsList(query: query)

        return try response.ok.body.json
    }

    func testFetchStationsList(limitToOneCountry: Bool = true) {
        Task {
            do {
                print("Fetching stations list...")
                let resp = try await getStationsList()

                if let countries = resp.countries {
                    print("Countries: \(countries.count)")

                    if limitToOneCountry, let first = countries.first {
                        print("First country title: \(first.title ?? "nil")")
                    }
                } else {
                    print("No countries returned")
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
