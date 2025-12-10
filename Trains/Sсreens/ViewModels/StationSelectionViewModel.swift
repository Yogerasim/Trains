import Combine

@MainActor
final class StationSelectionViewModel: ObservableObject {
    let city: City

    @Published var stations: [String] = []

    init(city: City) {
        self.city = city
        self.stations = city.stations.sorted()
    }
}
