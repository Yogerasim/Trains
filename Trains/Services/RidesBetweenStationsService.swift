import OpenAPIRuntime
import OpenAPIURLSession

typealias RidesResponse = Components.Schemas.SearchRidesResponse

protocol RidesBetweenStationsServiceProtocol {
    func getRides(from: String, to: String, date: String?) async throws -> RidesResponse
}

final class RidesBetweenStationsService: RidesBetweenStationsServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getRides(from: String, to: String, date: String?) async throws -> RidesResponse {
        let query = Operations.getRidesBetweenStations.Input.Query(
            apikey: apikey,
            from: from,
            to: to,
            date: date,
            transport_types: nil
        )

        let response = try await client.getRidesBetweenStations(query: query)
        return try response.ok.body.json
    }

    func testFetchRides() {
        Task {
            do {
                print("Fetching rides...")

                let rides = try await getRides(
                    from: "c146",
                    to: "c213",
                    date: "2025-11-07"
                )

                print("✅ total: \(rides.pagination?.total ?? 0)")
                print("✅ segments: \(rides.segments?.count ?? 0)")
                print("✅ interval segments: \(rides.interval_segments?.count ?? 0)")

            } catch {
                print("❌ Error fetching rides: \(error)")
            }
        }
    }
}
