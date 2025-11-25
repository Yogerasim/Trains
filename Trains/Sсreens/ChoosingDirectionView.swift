import SwiftUI

struct ChoosingDirectionView: View {

    @State private var fromTitle: String = "Откуда"
    @State private var toTitle: String = "Куда"
    @State private var showCityFrom = false
    @State private var showCityTo = false
    @State private var showStationFrom = false
    @State private var showStationTo = false
    @State private var selectedCityForStations = ""
    @State private var showStations = false
    
    var bothSelected: Bool {
        !fromTitle.contains("Откуда") &&
        !fromTitle.contains("Куда") &&
        !toTitle.contains("Откуда") &&
        !toTitle.contains("Куда")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            ZStack(alignment: .center) {
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(DesignSystem.Colors.blueUniversal)
                    .frame(width: 343)
                
                HStack(alignment: .center) {
                    
                    LazyVStack(spacing: 0) {
                        Button(action: { showCityFrom = true }) {
                            DirectionOptionButton(title: fromTitle)
                        }
                        .buttonStyle(.plain)
                        

                        Button(action: { showCityTo = true }) {
                            DirectionOptionButton(title: toTitle)
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .frame(width: 259)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: swapDirections) {
                        Image("Сhange")
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                    .padding(.trailing, 16)
                }
            }
            .frame(width: 343, height: 128)
            
            if bothSelected {
                withAnimation(.easeInOut) {
                    ButtonSearch(title: "Найти") {
                        showStations = true
                    }
                }
            }
        }
        
        
        .fullScreenCover(isPresented: $showCityFrom) {
            CitySelectionView { result in
                fromTitle = result
                showCityFrom = false
            }
        }
        .fullScreenCover(isPresented: $showCityTo) {
            CitySelectionView { result in
                toTitle = result
                showCityTo = false
            }
        }
        .fullScreenCover(isPresented: $showStations) {
            StationsScreenView(
                headerText: "\(fromTitle) → \(toTitle)",
                stations: mockStations,
                onBack: {
                    showStations = false
                }
            )
        }
    }
    private func swapDirections() {
        withAnimation(.easeInOut(duration: 0.25)) {
            let temp = fromTitle
            fromTitle = toTitle
            toTitle = temp
        }
    }
}
struct DirectionOptionButton: View {
    let title: String
    
    private var isPlaceholder: Bool {
        title == "Откуда" || title == "Куда"
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(isPlaceholder ? .gray : .black)
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}
let mockStations = [
    StationData(
        logoName: "RZHD",
        stationName: "РЖД",
        subtitle: "С пересадкой в Костроме",
        rightTopText: "16 января",
        leftBottomText: "22:30",
        middleBottomText: "9 часов",
        rightBottomText: "22:30"
    )
]



#Preview {
    MainTabView()
}
