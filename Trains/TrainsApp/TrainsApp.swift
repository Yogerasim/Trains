import SwiftUI

@main
private struct TrainsApp: App {
    @StateObject var appModel = AppViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appModel)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
