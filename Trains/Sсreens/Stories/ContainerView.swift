import SwiftUI

struct ContainerView: View {
    let story: Story
    private let cornerRadius: CGFloat = 40

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height

            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.black)
                    .frame(width: width, height: height)
                    .overlay(
                        story.backgroundImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .clipped()
                    )

                VStack(alignment: .leading, spacing: 20) {
                    Text(story.title)
                        .font(DesignSystem.Fonts.bold34)
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    Text(story.description)
                        .font(DesignSystem.Fonts.regular20)
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .padding(.bottom, 30)
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity,
                       alignment: .bottomLeading)
            }
            .frame(width: width, height: height)
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius)
            )
        }
    }
}

#Preview {
    ContainerView(story: .story6)
}
