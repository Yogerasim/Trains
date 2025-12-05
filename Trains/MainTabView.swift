import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChoosingDirectionView()
                .tabItem {
                    Image(selectedTab == 0 ? .scheduleActive : .schedule)
                }
                .tag(0)
            
            SettingsView()
                .tabItem {
                    Image(selectedTab == 1 ? .settingsActive : .settings)
                }
                .tag(1)
        }
        .labelStyle(.iconOnly)
    }
}

struct BlueScreen: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Settings")
                .font(.largeTitle)
                .foregroundStyle(.black)
        }
    }
}
