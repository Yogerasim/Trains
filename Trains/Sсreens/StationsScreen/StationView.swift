import SwiftUI

struct StationView: View {
    let logoURL: URL?
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

                Group {
                    if let url = logoURL {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(logoName)
                                .resizable()
                                .scaledToFill()
                                .opacity(0.3)
                        }
                    } else {
                        Image(logoName)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 38, height: 38)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: subtitle != nil ? 2 : 0) {
                    Text(stationName)
                        .font(DesignSystem.Fonts.regular17)
                        .foregroundStyle(.black)

                    if let subtitle {
                        Text(subtitle)
                            .font(DesignSystem.Fonts.regular12)
                            .foregroundStyle(DesignSystem.Colors.redUniversal)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                .layoutPriority(1)

                Spacer()

                Text(rightTopText)
                    .font(DesignSystem.Fonts.regular12)
                    .foregroundStyle(.black)
            }
            .padding(.horizontal, 10)
            .frame(width: 346, height: 52)
            .padding(.top, 10)

            HStack {
                Text(leftBottomText)
                    .font(DesignSystem.Fonts.regular17)
                    .foregroundStyle(.black)

                Spacer()

                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(height: 1)

                Spacer()

                Text(middleBottomText)
                    .font(DesignSystem.Fonts.regular12)
                    .foregroundStyle(.black)

                Spacer()

                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(height: 1)

                Spacer()

                Text(rightBottomText)
                    .font(DesignSystem.Fonts.regular17)
                    .foregroundStyle(.black)
            }
            .frame(width: 326, height: 52)
            .padding(.horizontal, 50)
        }
        .frame(width: 346, height: 104)
        .background(DesignSystem.Colors.lightGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack(spacing: 20) {
        StationView(
            logoURL: URL(string: "https://avatars.mds.yandex.net/get-rasp/123"),
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
