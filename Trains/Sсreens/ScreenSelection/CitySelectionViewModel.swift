import Combine
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession



@MainActor
final class CitySelectionViewModel: ObservableObject {

    @Published var cities: [City] = []
    @Published var isLoading = false
    @Published var showNoInternet = false
    @Published var showServerError = false

    private let api = StationsListService() // сервис по OpenAPI

    /// Загружает города и станции
    func load() async {
        isLoading = true
        showNoInternet = false
        showServerError = false

        do {
            let response = try await api.getAllStations()
            let citiesList = response.toCities()
            cities = citiesList
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    /// Обработка ошибок сети и сервера
    private func handleError(_ error: Error) {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            showNoInternet = true
        } else {
            showServerError = true
        }
    }
}

// MARK: - Модель города

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let stations: [String]
}

// MARK: - Преобразование ответа API в [City]

extension AllStationsResponseType {
    func toCities() -> [City] {
        guard let countries = countries else {
            print("❌ No countries in response")
            return []
        }

        var result: [City] = []

        for country in countries {
            let countryName = country.title ?? "Unknown Country"
            print("🌍 Country: \(countryName)")

            guard let regions = country.regions else { continue }

            for region in regions {
                let regionName = region.title ?? "Unknown Region"
                print("  📍 Region: \(regionName)")

                guard let settlements = region.settlements else { continue }

                for settlement in settlements {
                    let cityName = settlement.title ?? ""
                    guard !cityName.isEmpty else { continue }
                    print("    🏘 Settlement: \(cityName)")

                    let stations = (settlement.stations ?? [])
                        .compactMap { $0.title }
                        .sorted()

                    result.append(City(name: cityName, stations: stations))
                }
            }
        }

        let sorted = result.sorted { $0.name < $1.name }
        print("✅ Total cities: \(sorted.count)")
        return sorted
    }
}
