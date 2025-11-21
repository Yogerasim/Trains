import SwiftUI

struct ChoosingDirectionView: View {

    @State private var fromTitle: String = "Откуда"
    @State private var toTitle: String = "Куда"

    var body: some View {
        ZStack(alignment: .center) {

            RoundedRectangle(cornerRadius: 20)
                .fill(DesignSystem.Colors.BlueUniversal)
                .frame(width: 343)

            HStack(alignment: .center) {

                LazyVStack(spacing: 0) {
                    DirectionOptionButton(title: fromTitle)
                    DirectionOptionButton(title: toTitle)
                }
                .frame(width: 259)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.leading, 16)

                Spacer()

                Button(action: swapDirections) {
                    Image("Сhange")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                .padding(.trailing, 16)
            }
        }
        .frame(width: 343, height: 128)
    }

    private func swapDirections() {
        withAnimation(.easeInOut(duration: 0.25)) {
            let temp = fromTitle
            fromTitle = toTitle
            toTitle = temp
        }
    }
}

struct DirectionOptionButton: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
    }
}

#Preview {
    MainTabView()
}
