import Foundation
import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {

    // MARK: - Stored settings

    @AppStorage("themeMode")
    private var storedThemeMode: ThemeMode = .system

    // MARK: - Published state

    @Published var isDarkMode: Bool = false
    @Published var showAgreement: Bool = false

    // MARK: - Computed

    var appVersionText: String {
        "Версия 1.0 (beta)"
    }

    var apiInfoText: String {
        "Приложение использует API «Яндекс.Расписания»"
    }

    // MARK: - Init

    init() {
        syncFromStorage()
    }

    // MARK: - Actions

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

    // MARK: - Private

    private func syncFromStorage() {
        isDarkMode = storedThemeMode == .dark
    }
}
