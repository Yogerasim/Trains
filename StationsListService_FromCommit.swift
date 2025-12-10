import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStationsResponseType = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations(lang: String?) async throws -> AllStationsResponseType
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apiKey: String

    init(client: Client = APIConfig.client, apiKey: String = APIConfig.apiKey) {
        self.client = client
        self.apiKey = apiKey
    }

    func getAllStations(lang: String? = "ru_RU") async throws -> AllStationsResponseType {
        var urlComponents = URLComponents(string: "https://api.rasp.yandex-net.ru/v3.0/stations_list/")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        if let lang = lang {
            queryItems.append(URLQueryItem(name: "lang", value: lang))
        }
        urlComponents.queryItems = queryItems

        let request = URLRequest(url: urlComponents.url!)
        
        // Используем OpenAPIURLSession для запроса
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(AllStationsResponseType.self, from: data)
    }
}

extension StationsListService {

    /// Тестирование получения списка станций
    /// - Parameter limitToOneCountry: если true, выводится только первая страна для ускорения теста
    func testFetchStationsList(limitToOneCountry: Bool = false) {
        Task {
            do {
                let response = try await getAllStations()
                
                // Разворачиваем опциональный массив стран
                guard let countries = response.countries, !countries.isEmpty else {
                    print("❌ Нет стран в ответе")
                    return
                }

                let firstCountry = countries[0]
                print("✅ Получена страна: \(firstCountry.title)")

                if limitToOneCountry {
                    if let firstRegion = firstCountry.regions?.first {
                        print("  Регион: \(firstRegion.title)")

                        if let firstSettlement = firstRegion.settlements?.first {
                            print("    Населённый пункт: \(firstSettlement.title)")

                            if let firstStation = firstSettlement.stations?.first {
                                print("      Станция: \(firstStation.title) (\(firstStation.station_type ?? "тип неизвестен"))")
                            }
                        }
                    }
                    return
                }

                // Если limitToOneCountry == false, выводим количество стран
                print("✅ Всего стран: \(countries.count)")

            } catch {
                print("❌ Ошибка при тесте StationsListService: \(error)")
            }
        }
    }
}
