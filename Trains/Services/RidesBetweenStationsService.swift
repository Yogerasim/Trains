import OpenAPIRuntime
import Foundation
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
                print("\n=== 🚆 TEST FETCH RIDES ===")

                // 1. Берём реальные станции СПБ → Москва
                // Эти станции всегда существуют и всегда дают валидный ответ
                let from = "s9602494"   // СПБ Ладожский
                let to   = "s9603159"   // Москва Казанский

                // 2. Сегодня + 1 день (почти всегда доступная дата)
                let date = ISO8601DateFormatter().string(
                    from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                ).prefix(10) // "YYYY-MM-DD"

                print("→ from: \(from)")
                print("→ to: \(to)")
                print("→ date: \(date)")

                // 3. Пробуем загрузить рейсы
                let rides = try await getRides(
                    from: from,
                    to: to,
                    date: String(date)
                )

                // 4. Вывод
                print("=== ✅ RIDES LOADED ===")
                print("total: \(rides.pagination?.total ?? 0)")
                print("segments: \(rides.segments?.count ?? 0)")
                print("interval segments: \(rides.interval_segments?.count ?? 0)")

                if rides.pagination?.total == 0 {
                    print("⚠️ API вернул 0 результатов — возможно дата неактуальна")
                }

            } catch {
                print("❌ TEST RIDES FAILED")
                print("Error: \(error)")
            }
        }
    }
}
