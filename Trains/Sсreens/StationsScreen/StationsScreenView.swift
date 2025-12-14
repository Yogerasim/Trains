import SwiftUI

struct StationsScreenView: View {
    let headerText: String
    var onBack: () -> Void

    @StateObject private var vm: StationsScreenViewModel

    @State private var path = NavigationPath()
    @State private var hasActiveFilters = false
    @State private var filteredStations: [StationData] = []

    init(fromStationCode: String, toStationCode: String, headerText: String, onBack: @escaping () -> Void, searchService: SearchService) {
        _vm = StateObject(wrappedValue: StationsScreenViewModel(
            fromStationCode: fromStationCode,
            toStationCode: toStationCode,
            searchService: searchService
        ))
        self.headerText = headerText
        self.onBack = onBack
    }

    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                content
                    .navigationDestination(for: FilterNav.self) { _ in
                        FilterScreenViewWrapper(
                            path: $path,
                            hasActiveFilters: $hasActiveFilters,
                            filteredStations: $filteredStations,
                            allStations: vm.stations
                        )
                    }
                    .navigationDestination(for: InfoNav.self) { nav in
                        InfoScreenView(
                            viewModel: InfoScreenViewModel(
                                carrierCode: nav.carrierCode,
                                carrierService: CarrierService(
                                    client: APIConfig.client,
                                    apikey: APIConfig.apiKey
                                )
                            ),
                            onBack: {
                                path.removeLast()
                            }
                        )
                    }
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                Task {
                    await vm.load()
                }
            }
            .onChange(of: vm.stations) { newValue in
                filteredStations = newValue
            }

            if vm.showNoInternet {
                PlaceholderView(type: .noInternet)
                    .zIndex(10)
            } else if vm.showServerError {
                PlaceholderView(type: .serverError)
                    .zIndex(10)
            }
        }
    }

    private var content: some View {
        VStack(spacing: 30) {
            NavigationTitleView(title: "") { onBack() }

            Text(headerText)
                .font(DesignSystem.Fonts.bold24)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)

            if vm.stations.isEmpty && vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                Spacer()
            } else if filteredStations.isEmpty {
                PlaceholderView(type: .emptyMessage)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredStations) { station in
                            StationView(
                                logoURL: station.logoURL,
                                stationName: station.stationName,
                                subtitle: station.subtitle,
                                rightTopText: station.rightTopText,
                                leftBottomText: station.leftBottomText,
                                middleBottomText: station.middleBottomText,
                                rightBottomText: station.rightBottomText
                            )
                            .onTapGesture {
                                if let code = station.carrierCode {
                                    // Fill required InfoNav fields; InfoScreenViewModel will fetch real data by code.
                                    path.append(InfoNav(
                                        carrierName: station.stationName,
                                        imageName: "", // no local asset name; remote logo is used in InfoScreenViewModel
                                        info: [],      // will be populated after fetch
                                        carrierCode: code
                                    ))
                                }
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
                "Вечер 18:00 - 00:00",
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
