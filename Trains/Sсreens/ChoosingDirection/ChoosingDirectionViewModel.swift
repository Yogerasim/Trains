import SwiftUI

@Observable
final class ChoosingDirectionViewModel {

    // MARK: - Data
    var fromCity: String? = nil
    var toCity: String? = nil

    // MARK: - UI
    var screenState: ScreenState = .content
    var navigation: ChoosingDirectionNavigation? = nil

    // MARK: - Computed Titles
    var fromTitle: String {
        fromCity ?? "Откуда"
    }

    var toTitle: String {
        toCity ?? "Куда"
    }

    // MARK: - Logic
    var bothSelected: Bool {
        fromCity != nil && toCity != nil
    }

    // MARK: - Actions
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
