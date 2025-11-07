import OpenAPIRuntime
import OpenAPIURLSession

typealias Thread = Components.Schemas.ThreadResponse

protocol ThreadServiceProtocol {
    func getThread(uid: String, from: String?, to: String?, date: String?) async throws -> Thread
}

final class ThreadService: ThreadServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client = APIConfig.client, apikey: String = APIConfig.apiKey) {
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
                let scheduleService = ScheduleOnStationService(client: client, apikey: apikey)

                print("Fetching schedule for station: \(station)")

                // 1) Получаем расписание
                let schedule = try await scheduleService.getSchedule(
                    station: station,
                    date: nil,
                    transportTypes: "suburban",
                    direction: nil
                )

                guard let scheduleList = schedule.schedule, !scheduleList.isEmpty else {
                    print("❌ Schedule is empty")
                    return
                }

                // ✅ Берём только ОДНУ нитку для теста
                let firstThread = scheduleList.first?.thread

                guard let uid = firstThread?.uid else {
                    print("❌ No UID in first thread")
                    return
                }

                print("➡️ Fetching ONLY FIRST thread: \(uid)")

                // 2) Загружаем детали нитки — всего ОДИН запрос
                let threadDetails = try await self.getThread(uid: uid)

                print("✅ Thread details received:")
                print(threadDetails)

            } catch {
                print("❌ Error fetching thread: \(error)")
            }
        }
    }
}

