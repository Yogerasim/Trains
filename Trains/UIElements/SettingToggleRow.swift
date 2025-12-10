import SwiftUI

struct SettingToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Fonts.regular17)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .padding(.leading, 0)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .padding(.trailing, 16)
        }
        .frame(width: 375, height: 60)
        .contentShape(Rectangle())
    }
}

#Preview {
    StatefulPreviewWrapper(false) { value in
        SettingToggleRow(title: "Уведомления", isOn: value)
    }
}
