import SwiftUI

struct StoryCardView: View {
    let image: Image
    let title: String
    let isViewed: Bool
    let isCurrent: Bool

    private let width: CGFloat = 94
    private let height: CGFloat = 140

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            image
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
                .opacity(isViewed ? 0.5 : 1.0)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            if !isViewed {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(DesignSystem.Colors.blueUniversal, lineWidth: 4)
            }

            Text(title)
                .font(DesignSystem.Fonts.regular12)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .padding(.leading, 10)
                .padding(.bottom, 10)
                .opacity(isViewed ? 0.5 : 1.0)
                .lineSpacing(0.4)
                .frame(maxWidth: 85, alignment: .leading)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    VStack(spacing: 16) {
        StoryCardView(
            image: Story.story1.backgroundImage,
            title: Story.story1.title,
            isViewed: false,
            isCurrent: true
        )
        StoryCardView(
            image: Story.story2.backgroundImage,
            title: Story.story2.title,
            isViewed: true,
            isCurrent: false
        )
    }
}
