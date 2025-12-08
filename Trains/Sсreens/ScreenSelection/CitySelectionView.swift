import SwiftUI

struct CitySelectionView: View {
    @StateObject private var vm = CitySelectionViewModel()

    var onSelect: (String) -> Void = { _ in }

    @State private var selectedCity: City?

    var body: some View {
        NavigationStack {
            contentView
                .task {
                    await vm.load()
                }
                .navigationDestination(item: $selectedCity) { city in
                    StationSelectionView(city: city, onSelect: onSelect)
                }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if vm.showNoInternet {
            PlaceholderView(type: .noInternet)
        } else if vm.showServerError {
            PlaceholderView(type: .serverError)
        } else {
            SelectionListView(
                title: "Выбор города",
                items: vm.cities.map { $0.name }
            ) { cityName in
                if let city = vm.cities.first(where: { $0.name == cityName }) {
                    selectedCity = city
                }
            }
        }
    }
}
