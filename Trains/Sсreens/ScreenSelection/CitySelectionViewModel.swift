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
            cities = data.toCities()
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
        // Unwrap to the list of countries, or return empty if nil
        guard let countries = self.countries else { return [] }
        var result: [City] = []
        for country in countries {
            guard let regions = country.regions else { continue }
            for region in regions {
                guard let settlements = region.settlements else { continue }
                for settlement in settlements {
                    let name = settlement.title ?? ""
                    guard !name.isEmpty else { continue }
                    let stations = (settlement.stations ?? []).compactMap { $0.title }
                    result.append(City(name: name, stations: stations))
                }
            }
        }
        // Sort by city name
        result.sort { $0.name < $1.name }
        return result
    }
}
