import Combine
import Foundation

@MainActor
final class StationSelectionViewModel: ObservableObject {
    let city: City

    @Published var stations: [StationInfo] = []

    init(city: City) {
        self.city = city
        self.stations = city.stations.sorted { $0.title < $1.title }
    }
}
