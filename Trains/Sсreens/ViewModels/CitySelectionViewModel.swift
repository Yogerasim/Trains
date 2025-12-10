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
            // 1️⃣ Получаем все станции
            let allStations = try await stationsService.getAllStations()

            // 2️⃣ Фильтруем только российские города
            let citiesList = russianService.getRussianCities(from: allStations)

            cities = citiesList

        } catch {
            handleError(error)
        }

        print("🔥 Cities loaded into ViewModel: \(cities.count)")
        cities.prefix(20).forEach { print(" - \($0.name)") }
    }

    private func handleError(_ error: Error) {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            showNoInternet = true
        } else {
            showServerError = true
        }
    }
}
