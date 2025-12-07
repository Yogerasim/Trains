import SwiftUI

struct CitySelectionView: View {
    var onSelect: (String) -> Void = { _ in }

    private let cities = MockData.cities

    private struct CityItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
    }

    @State private var showNoInternet = false
    @State private var showServerError = false
    @State private var selectedCity: CityItem?

    var body: some View {
        NavigationStack {
            contentView

                .navigationDestination(item: $selectedCity) { cityItem in
                    StationSelectionView { station in
                        onSelect("\(cityItem.name) (\(station))")
                    }
                }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if showNoInternet {
            PlaceholderView(type: .noInternet)
        } else if showServerError {
            PlaceholderView(type: .serverError)
        } else {
            SelectionListView(
                title: "Выбор города",
                items: cities
            ) { city in
                selectedCity = CityItem(name: city)
            }
        }
    }
}
