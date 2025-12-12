import SwiftUI

struct StationSelectionView: View {

    @StateObject private var vm: StationSelectionViewModel
    var onSelect: (StationInfo) -> Void

    init(city: City, onSelect: @escaping (StationInfo) -> Void) {
        _vm = StateObject(wrappedValue: StationSelectionViewModel(city: city))
        self.onSelect = onSelect
    }

    var body: some View {
        VStack {
            SelectionListView(
                title: "Выбор станции",
                items: vm.stations.map { $0.title },
                isLoading: false
            ) { stationTitle in
                if let station = vm.stations.first(where: { $0.title == stationTitle }) {
                    onSelect(station)
                }
            }
        }
        .background(DesignSystem.Colors.background)
    }
}
