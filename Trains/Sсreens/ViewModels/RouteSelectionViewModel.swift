import Foundation
import Combine

@MainActor
final class RouteSelectionViewModel: ObservableObject {

    @Published var fromCity: City?
    @Published var toCity: City?

    @Published var fromStation: StationInfo?
    @Published var toStation: StationInfo?

    @Published var canSearch = false

    init() {}

    // MARK: - Пользователь выбрал станцию
    func selectFrom(city: City, station: StationInfo) {
        self.fromCity = city
        self.fromStation = station
        updateSearchState()
    }

    func selectTo(city: City, station: StationInfo) {
        self.toCity = city
        self.toStation = station
        updateSearchState()
    }

    private func updateSearchState() {
        canSearch = (fromStation?.code != nil) && (toStation?.code != nil)
    }
}
