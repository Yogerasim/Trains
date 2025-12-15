import Combine
import Foundation

@MainActor
final class StoryCardsScrollViewModel: ObservableObject {
    @Published private(set) var stories: [Story]
    @Published private(set) var viewedIDs: Set<UUID>
    @Published private(set) var currentStoryID: UUID?

    init(
        stories: [Story],
        viewedIDs: Set<UUID> = [],
        currentStoryID: UUID? = nil
    ) {
        self.stories = stories
        self.viewedIDs = viewedIDs
        self.currentStoryID = currentStoryID
    }

    func selectStory(at index: Int) {
        guard stories.indices.contains(index) else { return }

        let story = stories[index]
        currentStoryID = story.id
        viewedIDs.insert(story.id)
    }

    func isViewed(_ story: Story) -> Bool {
        viewedIDs.contains(story.id)
    }

    func isCurrent(_ story: Story) -> Bool {
        currentStoryID == story.id
    }
}
