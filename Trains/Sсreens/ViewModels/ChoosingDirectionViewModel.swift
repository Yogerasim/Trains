import Combine
import SwiftUI

@MainActor
final class ChoosingDirectionViewModel: ObservableObject {
    @Published var fromCity: City?
    @Published var toCity: City?
    @Published var fromStation: StationInfo?
    @Published var toStation: StationInfo?

    @Published var screenState: ScreenState = .content
    @Published var navigation: ChoosingDirectionNavigation?
    @Published var showStories: Bool = false
    @Published var selectedStoryIndex: Int = 0

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
    func handleStorySelection(
        storyID: Story.ID?,
        stories: [Story]
    ) {
        guard
            let id = storyID,
            let index = stories.firstIndex(where: { $0.id == id })
        else { return }

        selectedStoryIndex = index
        showStories = true
    }
}
