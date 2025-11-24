import SwiftUI

struct NavigationTitleView: View {

    let title: String
    var onBack: (() -> Void)? = nil

    var body: some View {
        HStack {
            Button(action: {
                onBack?()
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
            .padding(.leading, 16)

            Spacer()

            Text(title)
                .font(DesignSystem.Fonts.title)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

            Spacer()

            Rectangle()
                .fill(Color.clear)
                .frame(width: 20, height: 20)
                .padding(.trailing, 16)
        }
        .frame(width: 375, height: 42)
    }
}
#Preview {
    NavigationTitleView(title: "Выбор города")
}
