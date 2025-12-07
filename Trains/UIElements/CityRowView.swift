import SwiftUI

struct CityRowView: View {
    let city: String
    var onSelect: (() -> Void)? = nil

    var body: some View {
        Button(action: {
            onSelect?()
        }) {
            HStack {
                Text(city)
                    .font(DesignSystem.Fonts.regular17)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .padding(.leading, 16)

                Spacer()

                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .padding(.trailing, 16)
            }
            .frame(width: 375, height: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CityRowView(city: "Москва")
}
