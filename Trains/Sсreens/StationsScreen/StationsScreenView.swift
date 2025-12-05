import SwiftUI

struct StationsScreenView: View {
    
    let headerText: String
    let stations: [StationData]
    var onBack: (() -> Void)
    
    @State private var path = NavigationPath()
    @State private var hasActiveFilters = false
    @State private var filteredStations: [StationData] = []
    
    @State private var showNoInternet = false
    @State private var showServerError = false
    
    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                content
                    .navigationDestination(for: FilterNav.self) { _ in
                        FilterScreenViewWrapper(
                            path: $path,
                            hasActiveFilters: $hasActiveFilters,
                            filteredStations: $filteredStations,
                            allStations: stations
                        )
                    }
                    .navigationDestination(for: InfoNav.self) { info in
                        InfoScreenView(
                            carrierName: info.carrierName,
                            imageName: info.imageName,
                            infoItems: MockData.infoItems
                        )
                    }
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear { filteredStations = stations }
            
            if showNoInternet {
                ZStack {
                    Color.white.ignoresSafeArea()
                    PlaceholderView(type: .noInternet)
                }
                .zIndex(10)
            } else if showServerError {
                ZStack {
                    Color.white.ignoresSafeArea()
                    PlaceholderView(type: .serverError)
                }
                .zIndex(10)
            }
        }
    }
    
    private var content: some View {
        VStack(spacing: 30) {
            
            NavigationTitleView(title: "") {
                onBack()
            }
            
            Text(headerText)
                .font(DesignSystem.Fonts.bold24)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)
            
            if filteredStations.isEmpty {
                PlaceholderView(type: .emptyMessage)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredStations) { station in
                            StationView(
                                logoName: station.logoName,
                                stationName: station.stationName,
                                subtitle: station.subtitle,
                                rightTopText: station.rightTopText,
                                leftBottomText: station.leftBottomText,
                                middleBottomText: station.middleBottomText,
                                rightBottomText: station.rightBottomText
                            )
                            .onTapGesture {
                                path.append(
                                    InfoNav(
                                        carrierName: "ОАО «РЖД»",
                                        imageName: "Image",
                                        info: MockData.infoItems
                                    )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
            
            Spacer()
            
            PrimaryButton(title: "Уточнить время", showBadge: hasActiveFilters) {
                path.append(FilterNav())
            }
            .padding(.bottom, 16)
        }
        .background(DesignSystem.Colors.background)
    }
}

// MARK: - Wrapper для фильтров
struct FilterScreenViewWrapper: View {
    @Binding var path: NavigationPath
    @Binding var hasActiveFilters: Bool
    @Binding var filteredStations: [StationData]
    
    let allStations: [StationData]
    
    @State private var timeSelections = Array(repeating: false, count: 3)
    @State private var showTransfers = false
    
    var body: some View {
        FilterScreenView(
            timeOptions: [
                "Утро 06:00 - 12:00",
                "День 12:00 - 18:00",
                "Вечер 18:00 - 00:00"
            ],
            timeSelections: $timeSelections,
            showTransfers: $showTransfers,
            onBack: {
                path.removeLast()
            },
            onApply: {
                hasActiveFilters = timeSelections.contains(true) || showTransfers
                
                filteredStations = allStations.filter { _ in
                    hasActiveFilters ? Bool.random() : true
                }
                
                path.removeLast()
            }
        )
    }
}
// MARK: - Preview
#Preview {
    let sampleStations = [
        StationData(
            logoName: "RZHD",
            stationName: "РЖД",
            subtitle: "С пересадкой в Костроме",
            rightTopText: "16 января",
            leftBottomText: "22:30",
            middleBottomText: "9 часов",
            rightBottomText: "22:30"
        ),
        StationData(
            logoName: "FGK",
            stationName: "ФГК",
            subtitle: nil,
            rightTopText: "16 января",
            leftBottomText: "00:10",
            middleBottomText: "8 часов",
            rightBottomText: "08:10"
        )
    ]
    
    StationsScreenView(
        headerText: "Москва (Ярославский вокзал) → Санкт-Петербург (Балтийский вокзал)",
        stations: sampleStations,
        onBack: {}
    )
}
