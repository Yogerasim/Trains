import Combine
import SwiftUI

struct ChoosingDirectionView: View {
    @StateObject private var model = ChoosingDirectionViewModel()
    @StateObject private var appViewModel = AppViewModel()

    @StateObject private var storyVM = StoryCardsScrollViewModel(
        stories: Story.all
    )

    var body: some View {
        VStack(spacing: 16) {
            StoryCardsScrollView(viewModel: storyVM)
                .padding(.top, 16)
                .onReceive(storyVM.$currentStoryID) { id in
                    model.handleStorySelection(
                        storyID: id,
                        stories: storyVM.stories
                    )
                }

            Spacer().frame(height: 12)

            content
                .padding(.horizontal, 16)

            Spacer()
        }

        .fullScreenCover(item: $model.navigation) { nav in
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

        .fullScreenCover(isPresented: $model.showStories) {
            StoriesView(
                stories: storyVM.stories,
                startIndex: $model.selectedStoryIndex,
                onViewed: { id in
                    storyVM.selectStory(
                        at: storyVM.stories.firstIndex { $0.id == id } ?? 0
                    )
                },
                onClose: {
                    model.showStories = false
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
                VStack(spacing: .zero) {
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
