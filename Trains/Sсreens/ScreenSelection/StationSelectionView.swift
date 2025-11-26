import SwiftUI

struct StationSelectionView: View {
    var stations: [String] = [
        "Казанский вокзал", "Ладожский вокзал", "Ярославский вокзал",
        "Витебский вокзал", "Левобережная"
    ]
    
    var onSelect: (String) -> Void = { _ in }
    
    @State private var showNoInternet = false
    @State private var showServerError = false
    
    var body: some View {
        NavigationStack {
            if showNoInternet {
                PlaceholderView(type: .noInternet)
            } else if showServerError {
                PlaceholderView(type: .serverError)
            } else {
                SelectionListView(
                    title: "Выбор вокзала",
                    items: stations,
                    onSelect: onSelect
                )
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    StationSelectionView()
}
