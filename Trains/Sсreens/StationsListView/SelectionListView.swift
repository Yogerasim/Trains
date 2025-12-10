import SwiftUI

struct SelectionListView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let items: [String]
    let isLoading: Bool
    var onSelect: (String) -> Void = { _ in }

    @State private var searchText = ""

    private var filteredItems: [String] {
        if searchText.isEmpty { items }
        else { items.filter { $0.lowercased().contains(searchText.lowercased()) }}
    }

    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: title) {
                dismiss()
            }

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)

                TextField("Введите запрос", text: $searchText)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.top, 12)

            ScrollView {
                LazyVStack(spacing: 0) {
                    if isLoading {
                        ProgressView()
                            .controlSize(.large)
                            .tint(.gray)
                            .padding(.vertical, 150)
                    }

                    ForEach(filteredItems, id: \.self) { item in
                        CityRowView(city: item) {
                            onSelect(item)
                        }
                    }
                    
                    if !isLoading && filteredItems.isEmpty {
                        PlaceholderView(type: .noData)
                            .padding(.top, 50)
                    }
                }
                .padding(.top, 8)
            }
            .frame(maxHeight: .infinity)
        }
        .background(DesignSystem.Colors.background)
        .ignoresSafeArea(.keyboard)
    }
}

