import OpenAPIRuntime
import OpenAPIURLSession

typealias Thread = Components.Schemas.ThreadResponse

protocol ThreadServiceProtocol {
    func getThread(uid: String, from: String?, to: String?, date: String?) async throws -> Thread
}

final class ThreadService: ThreadServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getThread(uid: String, from: String? = nil, to: String? = nil, date: String? = nil) async throws -> Thread {
        let query = Operations.getThread.Input.Query(
            apikey: apikey,
            uid: uid,
            from: from,
            to: to,
            date: date,
            format: nil,
            lang: nil,
            show_systems: nil
        )
        let response = try await client.getThread(query: query)
        return try response.ok.body.json
    }

    func testFetchThread(station: String) {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )

                // 1) Получаем расписание на станции
                let scheduleService = ScheduleOnStationService(client: client, apikey: apikey)
                let schedule = try await scheduleService.getSchedule(
                    station: station,
                    date: nil,
                    transportTypes: nil,
                    direction: nil
                )

                // 2) Берем первый доступный UID рейса
                if let scheduleDict = schedule as? [String: Any],
                   let threads = scheduleDict["schedule"] as? [[String: Any]],
                   let firstThread = threads.first,
                   let uid = firstThread["uid"] as? String {
                    
                    // 3) Получаем детали нитки
                    let thread = try await getThread(uid: uid)
                    print("Successfully fetched thread: \(thread)")
                } else {
                    print("No threads available for this station")
                }
            } catch {
                print("Error fetching thread: \(error)")
            }
        }
    }
}
