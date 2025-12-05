import SwiftUI

struct PrimaryButton: View {
    
    let title: String
    var showBadge: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(DesignSystem.Colors.blueUniversal)
                    .frame(width: 343, height: 60)
                HStack(spacing: 8) {
                    Spacer()
                    Text(title)
                        .font(DesignSystem.Fonts.bold17)
                        .foregroundStyle(.white)
                    if showBadge {
                        Circle()
                            .fill(DesignSystem.Colors.redUniversal)
                            .frame(width: 8, height: 8)
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Уточнить время")
        PrimaryButton(title: "Уточнить время", showBadge: true)
    }
}
