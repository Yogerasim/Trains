import SwiftUI

@main
private struct TrainsApp: App {
    @StateObject var appModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appModel)
        }
    }
}
