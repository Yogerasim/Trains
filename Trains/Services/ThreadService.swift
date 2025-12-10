import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// Псевдоним для типа Thread
typealias Thread = Components.Schemas.ThreadStationsResponse

// Протокол для сервиса
protocol ThreadServiceProtocol {
    func getRouteStations(uid: String, date: String?) async throws -> Thread
}

// Конкретная реализация сервиса
final class ThreadService: ThreadServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouteStations(uid: String, date: String? = nil) async throws -> Thread {
        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid,
            date: date
        ))
        return try response.ok.body.json
    }
}



extension ThreadService {
    /// Асинхронный метод для отладки — печатает данные рейса в консоль
    func debugPrintRoute(uid: String, date: String? = nil) async {
        print("=== DEBUG THREAD START ===")
        do {
            let schedule = try await getRouteStations(uid: uid, date: date)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(schedule),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Successfully fetched thread:\n\(jsonString)")
            } else {
                print("Successfully fetched thread (debug description): \(schedule)")
            }
            
            if let arrival = schedule.stops?.first?.arrival {
                print("Дата прибытия первой остановки: \(arrival)")
            }
        } catch {
            print("❌ Ошибка debugPrintRoute: \(error)")
        }
        print("=== DEBUG THREAD END ===")
    }
}
