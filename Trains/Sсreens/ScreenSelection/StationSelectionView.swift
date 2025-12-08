import SwiftUI

struct StationSelectionView: View {
    @StateObject private var vm: StationSelectionViewModel

    var onSelect: (String) -> Void = { _ in }

    init(city: City, onSelect: @escaping (String) -> Void = { _ in }) {
        _vm = StateObject(wrappedValue: StationSelectionViewModel(city: city))
        self.onSelect = onSelect
    }

    var body: some View {
        NavigationStack {
            SelectionListView(
                title: "Выбор вокзала",
                items: vm.stations,
                onSelect: onSelect
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    StationSelectionView(
        city: City(
            name: "Москва",
            stations: ["Казанский вокзал", "Ярославский вокзал"]
        )
    )
}
