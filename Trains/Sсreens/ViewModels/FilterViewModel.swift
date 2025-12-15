import Combine
import Foundation

@MainActor
final class FilterViewModel: ObservableObject {
    enum TimeSlot: Int, CaseIterable {
        case morning
        case day
        case evening

        func contains(_ date: Date) -> Bool {
            let hour = Calendar.current.component(.hour, from: date)

            switch self {
            case .morning: return hour >= 6 && hour < 12
            case .day: return hour >= 12 && hour < 18
            case .evening: return hour >= 18 || hour < 6
            }
        }
    }

    @Published var timeSelections: [Bool] = Array(repeating: false, count: 3)
    @Published var showTransfers: Bool = false

    var hasActiveFilters: Bool {
        timeSelections.contains(true) || showTransfers
    }

    func apply(to stations: [StationData]) -> [StationData] {
        stations.filter { station in
            timeFilterPass(station) && transferFilterPass(station)
        }
    }

    private func timeFilterPass(_ station: StationData) -> Bool {
        guard timeSelections.contains(true),
              let date = station.departureDate
        else { return true }

        return TimeSlot.allCases.enumerated().contains { index, slot in
            timeSelections[index] && slot.contains(date)
        }
    }

    private func transferFilterPass(_ station: StationData) -> Bool {
        showTransfers ? station.hasTransfers : true
    }
}
