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

// Простой тестовый вызов API
func testFetchThread() {
    Task {
        do {
            // 1. Создаём клиент
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            // 2. Создаём сервис
            let service = ThreadService(
                client: client,
                apikey: "ВАШ_КЛЮЧ" // Замените на свой API-ключ
            )
            
            // 3. Вызываем метод и получаем нитку
            print("Fetching thread...")
            let thread = try await service.getRouteStations(
                uid: "0000000000", // Пример UID рейса
                date: "2025-12-10" // Пример даты
            )
            
            // 4. Печатаем результат
            print("Successfully fetched thread: \(thread)")
            
            // 5. Дополнительно: выводим первую дату прибытия
            if let arrival = thread.stops?.first?.arrival {
                print("Дата прибытия первой остановки: \(arrival)")
            }
        } catch {
            print("Error fetching thread: \(error)")
        }
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
