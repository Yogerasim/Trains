import SwiftUI

struct Story: Identifiable {
    let id = UUID()
    let backgroundImage: Image
    let title: String
    let description: String

    static let story1 = Story(
        backgroundImage: Image("Story1"),
        title: "Text Text Text Text Text Text Text Text Text Text",
        description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    )

    static let story2 = Story(
        backgroundImage: Image("Story2"),
        title: "Text Text Text Text Text Text Text Text Text Text",
        description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    )

    static let story3 = Story(
        backgroundImage: Image("Story3"),
        title: "Text Text Text Text Text Text Text Text Text Text",
        description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    )

    static let story4 = Story(
        backgroundImage: Image("Story4"),
        title: "Text Text Text Text Text Text Text Text Text Text",
        description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    )

    static let story5 = Story(
        backgroundImage: Image("Story5"),
        title: "Text Text Text Text Text Text Text Text Text Text",
        description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    )

    static let story6 = Story(
        backgroundImage: Image("Story6"),
        title: "Text Text Text Text Text Text Text Text Text Text",
        description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    )

    static let all: [Story] = [.story1, .story2, .story3, .story4, .story5, .story6]
}
