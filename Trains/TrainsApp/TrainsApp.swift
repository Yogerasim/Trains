import SwiftUI

enum ThemeMode: String {
    case system
    case light
    case dark
}

@main
private struct TrainsApp: App {
    @AppStorage("themeMode") private var themeMode: ThemeMode = .system

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(
                    themeMode == .system ? nil :
                    (themeMode == .dark ? .dark : .light)
                )
        }
    }
}
