import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStations = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations(lang: String?) async throws -> AllStations
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apiKey: String

    init(client: Client = APIConfig.client, apiKey: String = APIConfig.apiKey) {
        self.client = client
        self.apiKey = apiKey
    }

    func getAllStations(lang: String? = "ru_RU") async throws -> AllStations {
        var urlComponents = URLComponents(string: "https://api.rasp.yandex-net.ru/v3.0/stations_list/")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        if let lang = lang {
            queryItems.append(URLQueryItem(name: "lang", value: lang))
        }
        urlComponents.queryItems = queryItems

        let request = URLRequest(url: urlComponents.url!)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(AllStations.self, from: data)
    }
}


struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let stations: [String]
}
extension StationsListService {
    func debugPrintAllStations() async {
        print("=== DEBUG STATIONS START ===")

        do {
            let data = try await getAllStations()

            // Печатаем все города
            if let countries = data.countries,
               let russia = countries.first(where: { $0.title == "Россия" }),
               let regions = russia.regions {

                var allCities: [String] = []

                for region in regions {
                    for settlement in region.settlements ?? [] {
                        allCities.append(settlement.title ?? "")
                    }
                }

                let sorted = allCities.sorted()
                print("Всего населённых пунктов: \(sorted.count)")
                print("Первые 30 городов в алфавите:")
                sorted.prefix(30).forEach { print(" - \($0)") }
                print("Последние 30 городов в алфавите:")
                sorted.suffix(30).forEach { print(" - \($0)") }
            }

        } catch {
            print("❌ Ошибка debugPrintAllStations: \(error)")
        }

        print("=== DEBUG STATIONS END ===")
    }
}
