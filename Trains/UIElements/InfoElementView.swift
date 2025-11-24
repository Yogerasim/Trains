import SwiftUI

struct InfoElementView: View {

    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(DesignSystem.Fonts.regular17)
                .foregroundColor(.black)

            Text(subtitle)
                .font(DesignSystem.Fonts.regular12)
                .foregroundColor(DesignSystem.Colors.blueUniversal)
        }
        .frame(width: 375, height: 60, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.leading, 25)
    }
}

#Preview {
    VStack(spacing: 16) {
        InfoElementView(title: "Email", subtitle: "info@rzd.ru")
        InfoElementView(title: "Телефон", subtitle: "Телефон РЖД")
    }
}
