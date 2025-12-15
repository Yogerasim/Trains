import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                SettingToggleRow(
                    title: "Тёмная тема",
                    isOn: Binding(
                        get: { vm.isDarkMode },
                        set: { vm.toggleDarkMode($0) }
                    )
                )

                CityRowView(city: "Пользовательское соглашение") {
                    vm.openAgreement()
                }
            }

            Spacer()

            footer
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $vm.showAgreement) {
            UserAgreementView {
                vm.closeAgreement()
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 16) {
            Text(vm.apiInfoText)
                .font(DesignSystem.Fonts.regular12)
                .foregroundStyle(DesignSystem.Colors.textPrimary)

            Text(vm.appVersionText)
                .font(DesignSystem.Fonts.regular12)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    SettingsView()
}
