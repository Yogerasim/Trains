import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestStationsResponse = Components.Schemas.NearestStationsResponse

protocol NearestStationsServiceProtocol {
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStationsResponse
}

final class NearestStationsService: NearestStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStationsResponse {
        let query = Operations.getNearestStations.Input.Query(apikey: apikey, lat: lat, lng: lng, distance: distance)
        let response = try await client.getNearestStations(query: query)
        return try response.ok.body.json
    }
    
    func testFetchStations() {
        Task {
            do {
                print("Fetching stations...")
                let stationsResponse = try await getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                if let first = stationsResponse.stations?.first {
                    print("✅ First station: \(first.title ?? "nil") (\(first.code ?? "nil"))")
                } else {
                    print("❌ No stations")
                }
            } catch {
                print("❌ Error fetching stations: \(error)")
            }
        }
    }
}
