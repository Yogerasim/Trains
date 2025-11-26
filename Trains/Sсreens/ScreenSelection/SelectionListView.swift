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
                    .foregroundColor(.gray)
                
                TextField("Введите запрос", text: $searchText)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            if filteredItems.isEmpty {
                Spacer()
                PlaceholderView(type: .noData)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredItems, id: \.self) { item in
                            CityRowView(city: item) {
                                onSelect(item)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            
            Spacer()
        }
        .background(DesignSystem.Colors.background)
        .ignoresSafeArea(.keyboard)
    }
}
