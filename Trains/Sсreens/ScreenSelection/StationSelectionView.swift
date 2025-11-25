import SwiftUI

struct StationSelectionView: View {
    var stations: [String] = [
        "Казанский вокзал", "Ладожский вокзал", "Ярославский вокзал",
        "Витебский вокзал", "Левобережная"
    ]
    
    var onSelect: (String) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            SelectionListView(
                title: "Выбор вокзала",
                items: stations,
                onSelect: onSelect
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    StationSelectionView()
}
