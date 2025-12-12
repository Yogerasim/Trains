import SwiftUI

struct CitySelectionView: View {

    @StateObject private var vm = CitySelectionViewModel()
    var onSelect: (City, StationInfo) -> Void  // возвращаем город + станцию

    @State private var selectedCity: City?
    @State private var showStationSelection = false

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
                        showStationSelection = true
                    }
                }
            }
            .background(DesignSystem.Colors.background)
            .task {
                await vm.load()
            }
            .navigationDestination(isPresented: $showStationSelection) {
                if let city = selectedCity {
                    StationSelectionView(city: city) { station in
                        onSelect(city, station)
                        showStationSelection = false
                    }
                }
            }
        }
    }
}
