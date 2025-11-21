import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChoosingDirectionView()
                .tabItem { Image(selectedTab == 0 ? "Schedule_active" : "Schedule") }
                .tag(0)
            
            BlueScreen()
                .tabItem { Image(selectedTab == 1 ? "Settings_active" : "Settings") }
                .tag(1)
        }
        .labelStyle(.iconOnly)
    }
}

struct RedScreen: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Красная вкладка")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

struct BlueScreen: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Settings")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }
}
