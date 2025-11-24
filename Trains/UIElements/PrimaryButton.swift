import SwiftUI

struct PrimaryButton: View {

    let title: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: {
            action?()
        }) {
            Text(title)
                .font(DesignSystem.Fonts.title)
                .foregroundColor(.white)
                .frame(width: 343, height: 60)
                .background(DesignSystem.Colors.blueUniversal)
                .cornerRadius(16)
        }
    }
}

#Preview {
    PrimaryButton(title: "Уточнить время")
}
