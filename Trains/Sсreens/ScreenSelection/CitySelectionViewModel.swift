import Combine
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsListResponse = Components.Schemas.StationsListResponse

@MainActor
final class CitySelectionViewModel: ObservableObject {

    @Published var cities: [City] = []
    @Published var showNoInternet = false
    @Published var showServerError = false

    private let api = StationsListService()

    func load() async {
        do {
            let data = try await api.getStationsList()

            dump(data)
            let citiesList = data.toCities()
            dump(citiesList)

            cities = citiesList
        } catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        if (error as NSError).code == -1009 {
            showNoInternet = true
        } else {
            showServerError = true
        }
    }
}

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let stations: [String]
}

extension StationsListResponse {
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
