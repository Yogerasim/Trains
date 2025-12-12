import Combine
import Foundation

@MainActor
final class CitySelectionViewModel: ObservableObject {

    @Published var cities: [City] = []
    @Published var isLoading = false
    @Published var showNoInternet = false
    @Published var showServerError = false

    private let stationsService = StationsListService()
    private let russianService = RussianCitiesService()

    func load() async {
        isLoading = true
        showNoInternet = false
        showServerError = false
        defer { isLoading = false }

        do {
            let allStations = try await stationsService.getAllStations()
            let citiesList = russianService.getRussianCities(from: allStations)
            cities = citiesList
        } catch {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                showNoInternet = true
            } else {
                showServerError = true
            }
        }
    }
}
