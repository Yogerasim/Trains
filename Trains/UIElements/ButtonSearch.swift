import SwiftUI

struct ButtonSearch: View {
    let title: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: {
            action?()
        }) {
            Text(title)
                .font(DesignSystem.Fonts.bold17)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 150, height: 60)
        .background(DesignSystem.Colors.blueUniversal)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ButtonSearch(title: "Найти")
}
