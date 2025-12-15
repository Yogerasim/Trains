import Combine
import Foundation

@MainActor
final class RouteSelectionViewModel: ObservableObject {
    @Published var fromCity: City?
    @Published var toCity: City?

    @Published var fromStation: StationInfo?
    @Published var toStation: StationInfo?

    @Published var canSearch = false

    init() {}

    func selectFrom(city: City, station: StationInfo) {
        fromCity = city
        fromStation = station
        updateSearchState()
    }

    func selectTo(city: City, station: StationInfo) {
        toCity = city
        toStation = station
        updateSearchState()
    }

    private func updateSearchState() {
        canSearch = (fromStation?.code != nil) && (toStation?.code != nil)
    }
}
