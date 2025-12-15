import Combine
import SwiftUI

struct StoriesView: View {
    let stories: [Story]
    @Binding var startIndex: Int
    let onViewed: (UUID) -> Void
    let onClose: () -> Void

    struct Configuration {
        let secondsPerStory: TimeInterval
        let tickInterval: TimeInterval
        var progressPerTick: CGFloat {
            CGFloat(tickInterval / secondsPerStory)
        }

        init(secondsPerStory: TimeInterval = 5, tickInterval: TimeInterval = 0.05) {
            self.secondsPerStory = secondsPerStory
            self.tickInterval = tickInterval
        }
    }

    private let configuration = Configuration()

    @State private var currentIndex: Int = 0
    @State private var progress: CGFloat = 0
    @State private var timerCancellable: AnyCancellable?
    @State private var isViewAppeared: Bool = false
    @GestureState private var dragOffset: CGFloat = 0
    @State private var animateOffset: CGFloat = 0
    @State private var reportedViewed: Set<UUID> = []
    private var count: Int { stories.count }
    private var currentStory: Story { stories[safe: currentIndex] ?? stories.first! }

    init(
        stories: [Story],
        startIndex: Binding<Int>,
        onViewed: @escaping (UUID) -> Void,
        onClose: @escaping () -> Void
    ) {
        self.stories = stories
        _startIndex = startIndex
        self.onViewed = onViewed
        self.onClose = onClose
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width

            ZStack(alignment: .topTrailing) {
                let prev = stories[safe: (currentIndex - 1 + count) % count] ?? stories.first!
                let next = stories[safe: (currentIndex + 1) % count] ?? stories.first!

                ContainerView(story: prev)
                    .offset(x: -width + animateOffset + dragOffset)
                ContainerView(story: currentStory)
                    .offset(x: animateOffset + dragOffset)
                ContainerView(story: next)
                    .offset(x: width + animateOffset + dragOffset)

                ProgressBar(numberOfSections: count, progress: normalizedOverallProgress())
                    .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))

                CloseButton(action: {
                    stopTimer()
                    onClose()
                })
                .padding(.top, 57)
                .padding(.trailing, 12)
            }
            .contentShape(Rectangle())
            .gesture(dragGesture(screenWidth: width))
            .gesture(tapGesture(screenWidth: width))
            .onAppear {
                currentIndex = min(max(0, startIndex), max(0, count - 1))
                progress = 0
                reportViewedIfNeeded(for: currentStory)
                DispatchQueue.main.async {
                    startTimer()
                    isViewAppeared = true
                }
            }
            .onDisappear {
                stopTimer()
                isViewAppeared = false
            }
            .onChange(of: startIndex) { _, newValue in
                jumpTo(index: min(max(0, newValue), max(0, count - 1)))
            }
        }
    }

    private func tapGesture(screenWidth: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { value in
                let x = value.location.x
                let leftThreshold = screenWidth * 0.33
                if x < leftThreshold {
                    advanceToPreviousStory()
                } else {
                    advanceToNextStory()
                }
            }
    }

    private func dragGesture(screenWidth: CGFloat) -> some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                let swipe = value.translation.width
                if swipe < -80 {
                    animateOffset = -screenWidth
                    withAnimation(.easeOut(duration: 0.25)) {}
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        advanceToNextStory()
                        animateOffset = 0
                    }
                } else if swipe > 80 {
                    animateOffset = screenWidth
                    withAnimation(.easeOut(duration: 0.25)) {}
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        advanceToPreviousStory()
                        animateOffset = 0
                    }
                } else {
                    withAnimation(.spring()) {
                        animateOffset = 0
                    }
                }
            }
    }

    private func startTimer() {
        stopTimer()
        let pub = Timer.publish(every: configuration.tickInterval, on: .main, in: .common).autoconnect()
        timerCancellable = pub.sink { _ in
            tick()
        }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func resetTimerAndProgress() {
        progress = 0
        stopTimer()

        DispatchQueue.main.async {
            startTimer()
        }
    }

    private func tick() {
        guard isViewAppeared else { return }
        progress += configuration.progressPerTick
        if progress >= 1 {
            progress = 0
            advanceToNextStoryWithoutReset()
        }
    }

    private func advanceToNextStoryWithoutReset() {
        reportViewedIfNeeded(for: currentStory)
        currentIndex = (currentIndex + 1) % count
        startIndex = currentIndex
        reportViewedIfNeeded(for: currentStory)
    }

    private func normalizedOverallProgress() -> CGFloat {
        guard count > 0 else { return 0 }
        return (CGFloat(currentIndex) + progress) / CGFloat(count)
    }

    private func advanceToNextStory() {
        reportViewedIfNeeded(for: currentStory)
        let nextIndex = (currentIndex + 1) % count
        currentIndex = nextIndex

        startIndex = currentIndex
        progress = 0
        reportViewedIfNeeded(for: currentStory)
        resetTimerAndProgress()
    }

    private func advanceToPreviousStory() {
        let prev = (currentIndex - 1 + count) % count
        currentIndex = prev
        startIndex = currentIndex
        progress = 0
        reportViewedIfNeeded(for: currentStory)
        resetTimerAndProgress()
    }

    private func jumpTo(index: Int) {
        guard index != currentIndex, index >= 0, index < count else { return }
        currentIndex = index
        progress = 0
        reportViewedIfNeeded(for: currentStory)
        resetTimerAndProgress()
    }

    private func reportViewedIfNeeded(for story: Story) {
        guard !reportedViewed.contains(story.id) else { return }
        reportedViewed.insert(story.id)
        onViewed(story.id)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

#Preview {
    StoriesView(
        stories: Story.all,
        startIndex: .constant(0),
        onViewed: { _ in },
        onClose: {}
    )
}
