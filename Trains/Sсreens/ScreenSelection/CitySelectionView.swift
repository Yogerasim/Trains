import SwiftUI

struct CitySelectionView: View {

    @StateObject private var vm = CitySelectionViewModel()
    var onSelect: (String) -> Void = { _ in }

    @State private var selectedCity: City?

    var body: some View {
        NavigationStack {
            ZStack {
                SelectionListView(
                    title: "Выбор города",
                    items: vm.cities.map { $0.name },
                    isLoading: vm.isLoading
                ) { cityName in
                    if let city = vm.cities.first(where: { $0.name == cityName }) {
                        selectedCity = city
                    }
                }
                
            }
            .background(DesignSystem.Colors.background)
            .task {
                await vm.load()
            }
            .navigationDestination(item: $selectedCity) { city in
                StationSelectionView(city: city, onSelect: onSelect)
            }
        }
    }
}
