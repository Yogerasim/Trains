import SwiftUI

struct SelectionListView: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let items: [String]
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
                    ForEach(filteredItems, id: \.self) { item in
                        CityRowView(city: item) { onSelect(item) }
                    }
                }
                .padding(.top, 8)
            }
            .opacity(filteredItems.isEmpty ? 0 : 1)
            .animation(.easeInOut, value: filteredItems.isEmpty)

            PlaceholderView(type: .noData)
                .opacity(filteredItems.isEmpty ? 1 : 0)
                .animation(.easeInOut, value: filteredItems.isEmpty)
            
            Spacer()
        }
        .background(DesignSystem.Colors.background)
        .ignoresSafeArea(.keyboard)
    }
}
