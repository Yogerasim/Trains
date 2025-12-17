import SwiftUI

struct StationView: View {
    let logoURL: URL?

    let stationName: String
    let subtitle: String?
    let rightTopText: String
    let leftBottomText: String
    let middleBottomText: String
    let rightBottomText: String

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: 8) {

                logoImage

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

    // MARK: - Logo

    private var logoImage: some View {
        AsyncImage(url: logoURL) { phase in
            switch phase {
            case .empty:
                Color.clear
                    .frame(width: 38, height: 38)

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .cornerRadius(12)

            case .failure:
                Color.clear
                    .frame(width: 38, height: 38)

            @unknown default:
                EmptyView()
            }
        }
    }
}
#Preview {
    VStack(spacing: 20) {
        StationView(
            logoURL: URL(string: "https://yastat.net/s3/rasp/media/data/company/logo/logo.gif"),
            stationName: "РЖД / ФПК",
            subtitle: "С пересадкой в Костроме",
            rightTopText: "14 декабря",
            leftBottomText: "23:55",
            middleBottomText: "8 ч",
            rightBottomText: "07:55"
        )
    }
    .padding()
}
