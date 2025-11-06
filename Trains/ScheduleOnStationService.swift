import OpenAPIRuntime
import OpenAPIURLSession

// Псевдоним для сгенерированного типа
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

    // Тестовый вызов для проверки сервиса
    func testFetchSchedule() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = ScheduleOnStationService(client: client, apikey: "358e8b9d-a92c-4b0b-a840-9ca909f976d8")
                print("Fetching schedule...")
                
                let schedule = try await service.getSchedule(
                    station: "s9600213", // код станции Санкт-Петербурга в формате Яндекс Расписаний
                    date: nil,
                    transportTypes: "suburban", // если хочешь электрички
                    direction: "на Москву"      // пример направления
                )
                
                print("Successfully fetched schedule: \(schedule)")
            } catch {
                print("Error fetching schedule: \(error)")
            }
        }
    }
}
