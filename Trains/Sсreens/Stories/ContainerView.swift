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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(story.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text(story.description)
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.85))
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
