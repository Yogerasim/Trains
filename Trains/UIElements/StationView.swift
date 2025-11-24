import SwiftUI

struct StationView: View {

    let logoName: String
    let stationName: String
    let subtitle: String?
    let rightTopText: String
    let leftBottomText: String
    let middleBottomText: String
    let rightBottomText: String

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 8) {

                Image(logoName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 38, height: 38)
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: subtitle != nil ? 2 : 0) {
                    Text(stationName)
                        .font(DesignSystem.Fonts.regular17)
                        .foregroundColor(.black)

                    if let subtitle {
                        Text(subtitle)
                            .font(DesignSystem.Fonts.regular12)
                            .foregroundColor(DesignSystem.Colors.redUniversal)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                .layoutPriority(1)

                Spacer()

                Text(rightTopText)
                    .font(DesignSystem.Fonts.regular12)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 10)
            .frame(width: 346, height: 52)
            .padding(.top, 10)

            HStack {
                Text(leftBottomText)
                    .font(DesignSystem.Fonts.regular17)
                    .foregroundColor(.black)

                Spacer()

                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(height: 1)

                Spacer()

                Text(middleBottomText)
                    .font(DesignSystem.Fonts.regular12)
                    .foregroundColor(.black)

                Spacer()

                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(height: 1)

                Spacer()

                Text(rightBottomText)
                    .font(DesignSystem.Fonts.regular17)
                    .foregroundColor(.black)
            }
            .frame(width: 326, height: 52)
            .padding(.horizontal, 50)
        }
        .frame(width: 346, height: 104)
        .background(DesignSystem.Colors.lightGray)
        .cornerRadius(16)
    }
}

#Preview {
    VStack(spacing: 20) {
        StationView(
            logoName: "RZHD",
            stationName: "РЖД",
            subtitle: "С пересадкой в Костроме",
            rightTopText: "16 января",
            leftBottomText: "22:30",
            middleBottomText: "9 часов",
            rightBottomText: "22:30"
        )
    }
    .padding()
}
