import SwiftUI

struct CityRowView: View {

    let city: String
    var onSelect: (() -> Void)? = nil

    var body: some View {
        HStack {

            Text(city)
                .font(DesignSystem.Fonts.regular17)
                .foregroundColor(.black)
                .padding(.leading, 16)

            Spacer()

            Button(action: {
                onSelect?()
            }) {
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
            .padding(.trailing, 16)
        }
        .frame(width: 375, height: 60, alignment: .center)
    }
}

#Preview {
    CityRowView(city: "Москва")
}
