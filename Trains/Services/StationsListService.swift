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
        var urlComponents = URLComponents(string: "https:
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

extension StationsListService {

    func debugPrintAllStations() async {
        print("=== DEBUG STATIONS START ===")

        do {
            let data = try await getAllStations()

            if let countries = data.countries,
               let russia = countries.first(where: { $0.title == "Россия" }),
               let regions = russia.regions {

                var allCities: [String] = []

                for region in regions {
                    allCities.append(
                        contentsOf: region.settlements?
                            .compactMap { $0.title }
                            .filter { !$0.isEmpty } ?? []
                    )
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
