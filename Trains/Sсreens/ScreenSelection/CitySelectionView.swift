import SwiftUI

struct CitySelectionView: View {
    var onSelect: (String) -> Void = { _ in }
    
    private let cities = [
        "Москва",
        "Санкт-Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск"
    ]
    private struct CityItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
    }
    
    @State private var selectedCity: CityItem? = nil
    
    var body: some View {
        NavigationStack {
            SelectionListView(
                title: "Выбор города",
                items: cities,
                onSelect: { city in
                    selectedCity = CityItem(name: city)
                }
            )
            .navigationDestination(item: $selectedCity) { cityItem in
                StationSelectionView { station in
                    onSelect("\(cityItem.name) (\(station))")
                }
            }
        }
    }
}
