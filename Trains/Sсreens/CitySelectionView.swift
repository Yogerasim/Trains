import SwiftUI

struct CitySelectionView: View {

    @Environment(\.dismiss) private var dismiss
    var onSelect: (String) -> Void = { _ in }

    @State private var searchText: String = ""

    private let cities = [
        "Москва",
        "Санкт-Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск"
    ]

    var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            NavigationTitleView(title: "Выбор города") {
                dismiss()
            }

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Введите запрос", text: $searchText)
                    .font(DesignSystem.Fonts.regular17)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 12)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredCities, id: \.self) { city in
                        CityRowView(city: city) {
                            onSelect(city)
                            dismiss()
                        }
                    }
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    CitySelectionView()
}
