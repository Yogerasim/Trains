import OpenAPIRuntime
import OpenAPIURLSession

// заменил alias на тот, что соответствует YAML
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = NearestStationsService(client: client, apikey: "358e8b9d-a92c-4b0b-a840-9ca909f976d8")
                print("Fetching stations...")
                let stationsResponse = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                // Пример того, как взять первый station код — проверь имена полей в сгенерированной модели
                if let stations = stationsResponse.stations, let first = stations.first {
                    print("First station code: \(first.code ?? "nil") title: \(first.title ?? "nil")")
                } else {
                    print("No stations in response")
                }
            } catch {
                print("Error fetching stations: \(error)")
            }
        }
    }
}
