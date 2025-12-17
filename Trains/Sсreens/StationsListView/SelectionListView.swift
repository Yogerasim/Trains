import SwiftUI

struct SelectionListView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let items: [String]
    let isLoading: Bool
    var onSelect: (String) -> Void = { _ in }

    @State private var searchText = ""

    var body: some View {
        VStack(spacing: .zero) {
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
            .padding(.vertical, 12)

            List {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                }

                ForEach(filteredItems, id: \.self) { item in
                    CityRowView(city: item) {
                        onSelect(item)
                    }
                    .listRowInsets(.none)
                    .listRowSeparator(.hidden)
                    .listRowBackground(DesignSystem.Colors.background)
                }

                if !isLoading && filteredItems.isEmpty {
                    PlaceholderView(type: .noData)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .background(DesignSystem.Colors.background)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            print("📋 ITEMS COUNT:", items.count)
            print("📋 NON EMPTY:", items.filter { !$0.isEmpty }.count)
        }
    }

    private var filteredItems: [String] {
        let cleanItems = items.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        if searchText.isEmpty {
            return cleanItems
        } else {
            return cleanItems.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
