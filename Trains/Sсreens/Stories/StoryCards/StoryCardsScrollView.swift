import SwiftUI

struct StoryCardsScrollView: View {
    let stories: [Story]
    let onSelect: (Int) -> Void

    let viewedIDs: Set<UUID>
    let currentStoryID: UUID?

    init(
        stories: [Story],
        onSelect: @escaping (Int) -> Void,
        viewedIDs: Set<UUID>,
        currentStoryID: UUID?
    ) {
        self.stories = stories
        self.onSelect = onSelect
        self.viewedIDs = viewedIDs
        self.currentStoryID = currentStoryID
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                    StoryCardView(
                        image: story.backgroundImage,
                        title: story.title,
                        isViewed: viewedIDs.contains(story.id),
                        isCurrent: currentStoryID == story.id
                    )
                    .onTapGesture {
                        onSelect(index)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 160)
    }
}

#Preview {
    StoryCardsScrollView(
        stories: Story.all,
        onSelect: { _ in },
        viewedIDs: [],
        currentStoryID: nil
    )
}
