import Combine
import Foundation
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @AppStorage("themeMode")
    private var storedThemeMode: ThemeMode = .system

    @Published var isDarkMode: Bool = false
    @Published var showAgreement: Bool = false

    var appVersionText: String {
        "Версия 1.0 (beta)"
    }

    var apiInfoText: String {
        "Приложение использует API «Яндекс.Расписания»"
    }

    init() {
        syncFromStorage()
    }

    func toggleDarkMode(_ isOn: Bool) {
        storedThemeMode = isOn ? .dark : .system
        isDarkMode = isOn
    }

    func openAgreement() {
        showAgreement = true
    }

    func closeAgreement() {
        showAgreement = false
    }

    private func syncFromStorage() {
        isDarkMode = storedThemeMode == .dark
    }
}
