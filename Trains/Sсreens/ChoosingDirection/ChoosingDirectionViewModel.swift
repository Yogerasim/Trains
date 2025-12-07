import SwiftUI

@Observable
final class ChoosingDirectionViewModel {
    var fromCity: String?
    var toCity: String?

    var screenState: ScreenState = .content
    var navigation: ChoosingDirectionNavigation?

    var fromTitle: String {
        fromCity ?? "Откуда"
    }

    var toTitle: String {
        toCity ?? "Куда"
    }

    var bothSelected: Bool {
        fromCity != nil && toCity != nil
    }

    func selectCityFrom(_ city: String) {
        fromCity = city
        navigation = nil
    }

    func selectCityTo(_ city: String) {
        toCity = city
        navigation = nil
    }

    func openCityFrom() {
        navigation = .cityFrom
    }

    func openCityTo() {
        navigation = .cityTo
    }

    func openStations() {
        navigation = .stations
    }

    func swapDirections() {
        let temp = fromCity
        fromCity = toCity
        toCity = temp
    }
}
