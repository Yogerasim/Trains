import SwiftUI

struct ChoosingDirectionView: View {
    
    @State private var model = ChoosingDirectionViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            content
        }
        .fullScreenCover(item: $model.navigation) { nav in
            switch nav {
            case .cityFrom:
                CitySelectionView { city in
                    model.selectCityFrom(city)
                }
            case .cityTo:
                CitySelectionView { city in
                    model.selectCityTo(city)
                }
            case .stations:
                StationsScreenView(
                    headerText: "\(model.fromTitle) → \(model.toTitle)",
                    stations: MockData.stationCards,
                    onBack: { model.navigation = nil }
                )
            }
        }
    }
    
    
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        switch model.screenState {
        case .content:
            VStack(spacing: 16) {
                directionCard
                
                ButtonSearch(title: "Найти") {
                    model.openStations()
                }
                .opacity(model.bothSelected ? 1 : 0)
                .animation(.easeInOut, value: model.bothSelected)
            }
            
        case .noInternet:
            PlaceholderView(type: .noInternet)
                .frame(maxHeight: .infinity)
            
        case .serverError:
            PlaceholderView(type: .serverError)
                .frame(maxHeight: .infinity)
        }
    }
    
    
    // MARK: - Direction card
    private var directionCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(DesignSystem.Colors.blueUniversal)
                .frame(width: 343)
            
            HStack {
                VStack(spacing: 0) {
                    Button(action: { model.openCityFrom() }) {
                        DirectionOptionButton(title: model.fromTitle)
                    }
                    
                    Button(action: { model.openCityTo() }) {
                        DirectionOptionButton(title: model.toTitle)
                    }
                }
                .frame(width: 259)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.leading, 16)
                
                Spacer()
                
                Button(action: model.swapDirections) {
                    Image("Сhange")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                .padding(.trailing, 16)
            }
        }
        .frame(width: 343, height: 128)
    }
}


// MARK: - DirectionOptionButton
private struct DirectionOptionButton: View {
    let title: String
    
    private var isPlaceholder: Bool {
        title == "Откуда" || title == "Куда"
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(isPlaceholder ? .gray : .black)
            
            Spacer()
        }
        .frame(height: 48)
        .padding(.horizontal, 16) 
        .contentShape(Rectangle())
    }
}
