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
    private let cacheKey = "cachedCities"

    init() {
        // загружаем из кэша сразу, если есть
        if let cached = loadCitiesFromCache() {
            self.cities = cached
        }
    }

    func load() async {
        // Лоадер включаем только если список пустой
        if cities.isEmpty { isLoading = true }
        showNoInternet = false
        showServerError = false
        defer { isLoading = false }

        do {
            let allStations = try await stationsService.getAllStations()
            let citiesList = russianService
                .getRussianCities(from: allStations)
                .filter {
                    !$0.name
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty
                }

            self.cities = citiesList
            saveCitiesToCache(citiesList)
        } catch {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                showNoInternet = true
            } else {
                showServerError = true
            }
        }
    }

    private func saveCitiesToCache(_ cities: [City]) {
        if let data = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(data, forKey: cacheKey)
        }
    }

    private func loadCitiesFromCache() -> [City]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        return try? JSONDecoder().decode([City].self, from: data)
    }
}
