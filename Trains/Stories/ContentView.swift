import SwiftUI
import Combine

struct ContentView: View {
    struct Configuration {
        let timerTickInternal: TimeInterval
        let progressPerTick: CGFloat
        
        init(
            storiesCount: Int,
            secondsPerStory: TimeInterval = 5,
            timerTickInternal: TimeInterval = 0.05
        ) {
            self.timerTickInternal = timerTickInternal
            self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInternal
        }
    }
    private let stories: [Story]
    private let configuration: Configuration
    
    @State private var progress: CGFloat = 0
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?
    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var animateOffset: CGFloat = 0
    
    private var count: Int { stories.count }
    
    private var currentIndex: Int { min(Int(progress * CGFloat(count)), count - 1) }
    private var nextIndex: Int { (currentIndex + 1) % count }
    private var prevIndex: Int { (currentIndex - 1 + count) % count }
    
    private var currentStory: Story { stories[currentIndex] }
    private var nextStory: Story { stories[nextIndex] }
    private var prevStory: Story { stories[prevIndex] }
    
    init(stories: [Story] = [ .story1, .story2, .story3, .story4, .story5, .story6, .story7 ]) {
        self.stories = stories
        configuration = Configuration(storiesCount: stories.count)
        timer = Self.createTimer(configuration: configuration)
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            
            ZStack(alignment: .topTrailing) {
                StoryView(story: prevStory)
                    .offset(x: -width + animateOffset + dragOffset)
                StoryView(story: currentStory)
                    .offset(x: animateOffset + dragOffset)
                StoryView(story: nextStory)
                    .offset(x: width + animateOffset + dragOffset)
                ProgressBar(numberOfSections: stories.count, progress: progress)
                    .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))
                
                CloseButton(action: { print("Close Story") })
                    .padding(.top, 57)
                    .padding(.trailing, 12)
            }
            
            .gesture(dragGesture(screenWidth: width))
            .onReceive(timer) { _ in timerTick() }
            .onAppear { startTimer() }
            .onDisappear { cancellable?.cancel() }
            .gesture(
                TapGesture()
                    .onEnded {
                        advanceToNextStory()
                        resetTimer()
                    }
            )
            
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
                    swipeToNext(screenWidth: screenWidth)
                } else if swipe > 80 {
                    swipeToPrev(screenWidth: screenWidth)
                } else {
                    animateOffset = 0
                }
            }
    }
    private func swipeToNext(screenWidth: CGFloat) {
        animateOffset = -screenWidth
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            advanceToNextStory()
            animateOffset = 0
        }
    }
    private func swipeToPrev(screenWidth: CGFloat) {
        animateOffset = screenWidth
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            advanceToPreviousStory()
            animateOffset = 0
        }
    }
    private func timerTick() {
        var next = progress + configuration.progressPerTick
        if next >= 1 { next = 0 }
        progress = next
    }
    private func advanceToNextStory() {
        progress = CGFloat((currentIndex + 1) % count) / CGFloat(count)
        resetTimer()
    }
    private func advanceToPreviousStory() {
        progress = CGFloat((currentIndex - 1 + count) % count) / CGFloat(count)
        resetTimer()
    }
    private func startTimer() {
        timer = Self.createTimer(configuration: configuration)
        cancellable = timer.connect()
    }
    private func resetTimer() {
        cancellable?.cancel()
        startTimer()
    }
    private static func createTimer(configuration: Configuration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }
}

#Preview {
    ContentView()
}
