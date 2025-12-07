import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleOnStation = Components.Schemas.ScheduleOnStationResponse

protocol ScheduleOnStationServiceProtocol {
    func getSchedule(
        station: String,
        date: String?,
        transportTypes: String?,
        direction: String?
    ) async throws -> ScheduleOnStation
}

final class ScheduleOnStationService: ScheduleOnStationServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getSchedule(
        station: String,
        date: String?,
        transportTypes: String?,
        direction: String?
    ) async throws -> ScheduleOnStation {
        let query = Operations.getScheduleOnStation.Input.Query(
            apikey: apikey,
            station: station,
            date: date,
            transport_types: transportTypes,
            direction: direction,
            result_timezone: nil
        )

        let response = try await client.getScheduleOnStation(query: query)
        return try response.ok.body.json
    }

    func testFetchSchedule() {
        Task {
            do {
                print("Fetching schedule...")

                let schedule = try await getSchedule(
                    station: "s9600213",
                    date: nil,
                    transportTypes: "suburban",
                    direction: nil
                )

                print("✅ Schedule fetched, segments: \(schedule.schedule?.count ?? 0)")
            } catch {
                print("❌ Error fetching schedule: \(error)")
            }
        }
    }
}
