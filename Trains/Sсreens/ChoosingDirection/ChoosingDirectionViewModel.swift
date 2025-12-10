import SwiftUI

@Observable
final class ChoosingDirectionViewModel {
    var fromCity: String?
    var toCity: String?
    var fromStation: String?
    var toStation: String?

    var screenState: ScreenState = .content
    var navigation: ChoosingDirectionNavigation?

    var fromTitle: String {
        if let city = fromCity, let station = fromStation {
            return "\(city) (\(station))"
        }
        return fromCity ?? "Откуда"
    }

    var toTitle: String {
        if let city = toCity, let station = toStation {
            return "\(city) (\(station))"
        }
        return toCity ?? "Куда"
    }

    var bothSelected: Bool {
        fromCity != nil && toCity != nil
    }

    func selectCityFrom(_ city: String) {
        fromCity = city
        fromStation = nil
        navigation = nil
    }

    func selectStationFrom(_ station: String) {
        fromStation = station
        navigation = nil
    }

    func selectCityTo(_ city: String) {
        toCity = city
        toStation = nil
        navigation = nil
    }

    func selectStationTo(_ station: String) {
        toStation = station
        navigation = nil
    }

    func openCityFrom() { navigation = .cityFrom }
    func openCityTo() { navigation = .cityTo }
    func openStations() { navigation = .stations }

    func swapDirections() {
        let tempCity = fromCity
        let tempStation = fromStation

        fromCity = toCity
        fromStation = toStation

        toCity = tempCity
        toStation = tempStation
    }
}
