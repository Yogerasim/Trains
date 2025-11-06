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

                let scheduleService = ScheduleOnStationService(client: client, apikey: apikey)

                print("Fetching schedule for station: \(station)")

                // 1) Получаем расписание по станции
                let schedule = try await scheduleService.getSchedule(
                    station: station,
                    date: nil,
                    transportTypes: "suburban",
                    direction: nil
                )

                guard let scheduleList = schedule.schedule else {
                    print("❌ No schedule field in response")
                    return
                }

                if scheduleList.isEmpty {
                    print("❌ Schedule is empty for this station")
                    return
                }

                print("✅ Found \(scheduleList.count) schedule entries")

                // 2) Берём UID из каждого thread внутри schedule
                for (index, item) in scheduleList.enumerated() {

                    guard let thread = item.thread else {
                        print("⚠️ schedule[\(index)] has no thread object")
                        continue
                    }

                    guard let uid = thread.uid else {
                        print("⚠️ schedule[\(index)] thread has no uid")
                        continue
                    }

                    print("➡️ Fetching thread \(index + 1): UID = \(uid)")

                    let threadDetails = try await self.getThread(uid: uid)

                    print("✅ Thread \(uid) details received:")
                    print(threadDetails)
                }

            } catch {
                print("❌ Error fetching thread: \(error)")
            }
        }
    }
}
