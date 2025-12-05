import SwiftUI

struct NavigationTitleView: View {
    
    let title: String
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            onBack?()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .padding(.leading, 16)
                
                Spacer()
                
                Text(title)
                    .font(DesignSystem.Fonts.bold17)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 16)
            }
            .frame(height: 42)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationTitleView(title: "Выбор города")
}
