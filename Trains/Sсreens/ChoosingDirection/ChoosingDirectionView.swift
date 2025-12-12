import SwiftUI

struct ChoosingDirectionView: View {
    // model должен быть StateObject, т.к. ChoosingDirectionViewModel — класс ObservableObject
    @StateObject private var model = ChoosingDirectionViewModel()
    @StateObject private var viewModel = AppViewModel()

    @State private var showStories = false
    @State private var selectedIndex = 0
    @State private var viewedStoryIDs: Set<UUID> = []
    let stories = Story.all

    var body: some View {
        VStack(spacing: 16) {
            StoryCardsScrollView(
                stories: stories,
                onSelect: { index in
                    selectedIndex = index
                    DispatchQueue.main.async {
                        showStories = true
                    }
                },
                viewedIDs: viewedStoryIDs,
                currentStoryID: nil
            )
            .padding(.top, 16)

            Spacer().frame(height: 12)

            content
                .padding(.horizontal, 16)

            Spacer()
        }
        .fullScreenCover(item: $model.navigation) { (nav: ChoosingDirectionNavigation) in
            switch nav {
            case .cityFrom:
                CitySelectionView { city, station in
                    model.selectFrom(city: city, station: station)
                }

            case .cityTo:
                CitySelectionView { city, station in
                    model.selectTo(city: city, station: station)
                }

            case .stations:
                StationsScreenView(
                    fromStationCode: model.fromStation?.code ?? "",
                    toStationCode: model.toStation?.code ?? "",
                    headerText: "\(model.fromTitle) → \(model.toTitle)",
                    onBack: { model.navigation = nil },
                    searchService: SearchService(
                        client: APIConfig.makeClient(),
                        apikey: APIConfig.apiKey
                    )
                )
            }
        }
        .fullScreenCover(isPresented: $showStories) {
            StoriesView(
                stories: stories,
                startIndex: $selectedIndex,
                onViewed: { id in
                    viewedStoryIDs.insert(id)
                },
                onClose: {
                    showStories = false
                }
            )
        }
    }

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

    private var directionCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(DesignSystem.Colors.blueUniversal)

            HStack {
                VStack(spacing: 0) {
                    Button(action: { model.openCityFrom() }) {
                        DirectionOptionButton(title: model.fromTitle)
                    }

                    Button(action: { model.openCityTo() }) {
                        DirectionOptionButton(title: model.toTitle)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()

                Button(action: model.swapDirections) {
                    Image("Сhange")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 128)
        .frame(maxWidth: .infinity)
    }
}

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

#Preview {
    MainTabView()
}
