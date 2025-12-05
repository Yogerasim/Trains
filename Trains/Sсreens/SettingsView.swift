import SwiftUI

struct SettingsView: View {
    @AppStorage("themeMode") private var themeMode: ThemeMode = .system

    private var isDarkMode: Binding<Bool> {
        Binding(
            get: { themeMode == .dark },
            set: { themeMode = $0 ? .dark : .system }
        )
    }
    
    @State private var showAgreement = false
    
    var body: some View {
        
        VStack {
            VStack(spacing: 0) {
                SettingToggleRow(title: "Тёмная тема", isOn: isDarkMode)
                CityRowView(city: "Пользовательское соглашение") {
                    showAgreement = true
                }
            }
            Spacer()
            VStack(spacing: 16) {
                Text("Приложение использует API «Яндекс.Расписания»")
                    .font(DesignSystem.Fonts.regular12)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                
                Text("Версия 1.0 (beta)")
                    .font(DesignSystem.Fonts.regular12)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
            }
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $showAgreement) {   // ← тут
                    UserAgreementView {
                        showAgreement = false         // ← закрываем
                    }
                }
        
    }
}

#Preview {
    SettingsView()
}
