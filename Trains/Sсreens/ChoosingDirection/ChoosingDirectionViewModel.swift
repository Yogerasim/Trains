import SwiftUI
import Combine

@MainActor
final class ChoosingDirectionViewModel: ObservableObject {
    @Published var fromCity: City?
    @Published var toCity: City?
    @Published var fromStation: StationInfo?
    @Published var toStation: StationInfo?

    @Published var screenState: ScreenState = .content
    @Published var navigation: ChoosingDirectionNavigation?

    var fromTitle: String {
        if let c = fromCity, let s = fromStation {
            return "\(c.name) (\(s.title))"
        }
        return fromCity?.name ?? "Откуда"
    }

    var toTitle: String {
        if let c = toCity, let s = toStation {
            return "\(c.name) (\(s.title))"
        }
        return toCity?.name ?? "Куда"
    }

    var bothSelected: Bool {
        fromStation != nil && toStation != nil
    }

    func selectFrom(city: City, station: StationInfo) {
        fromCity = city
        fromStation = station
        navigation = nil
    }

    func selectTo(city: City, station: StationInfo) {
        toCity = city
        toStation = station
        navigation = nil
    }

    func openCityFrom() { navigation = .cityFrom }
    func openCityTo() { navigation = .cityTo }
    func openStations() { navigation = .stations }

    func swapDirections() {
        swap(&fromCity, &toCity)
        swap(&fromStation, &toStation)
    }
}
