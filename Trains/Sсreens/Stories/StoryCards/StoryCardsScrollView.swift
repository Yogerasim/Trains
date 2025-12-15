import SwiftUI

struct StoryCardsScrollView: View {
    @StateObject private var vm: StoryCardsScrollViewModel

    init(viewModel: StoryCardsScrollViewModel) {
        _vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(vm.stories.enumerated()), id: \.element.id) { index, story in
                    StoryCardView(
                        image: story.backgroundImage,
                        title: story.title,
                        isViewed: vm.isViewed(story),
                        isCurrent: vm.isCurrent(story)
                    )
                    .onTapGesture {
                        vm.selectStory(at: index)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 160)
    }
}
