import SwiftUI

struct ButtonSearch: View {
    
    let title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            Text(title)
                .font(DesignSystem.Fonts.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 150, height: 60)
        .background(DesignSystem.Colors.blueUniversal)
        .cornerRadius(16)
    }
}

#Preview {
    ButtonSearch(title: "Найти")
}
