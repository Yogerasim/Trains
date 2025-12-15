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
        return try decoder.decode(AllStationsResponseType.self, from: data)
    }
}

extension StationsListService {

    
    

    func testFetchStationsList(limitToOneCountry: Bool = false) {
        Task {
            do {
                let response = try await getAllStations()
                
                
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

                
                print("✅ Всего стран: \(countries.count)")

            } catch {
                print("❌ Ошибка при тесте StationsListService: \(error)")
            }
        }
    }
}
