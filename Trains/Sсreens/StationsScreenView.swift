import SwiftUI

struct StationsScreenView: View {

    let headerText: String
    let stations: [StationData]

    var body: some View {
        VStack(spacing: 0) {

            NavigationTitleView(title: "") {
                print("Назад")
            }

            ScrollView {
                VStack(spacing: 16) {

                    Text(headerText)
                        .font(DesignSystem.Fonts.bigTitle2)
                        .foregroundColor(.black)
                        .frame(width: 343, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 16)

                    VStack(spacing: 16) {
                        ForEach(stations) { station in
                            StationView(
                                logoName: station.logoName,
                                stationName: station.stationName,
                                subtitle: station.subtitle,
                                rightTopText: station.rightTopText,
                                leftBottomText: station.leftBottomText,
                                middleBottomText: station.middleBottomText,
                                rightBottomText: station.rightBottomText
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }

            Spacer()

            PrimaryButton(title: "Уточнить время") {
                print("Кнопка нажата")
            }
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
    }
}

struct StationData: Identifiable {
    let id = UUID()
    let logoName: String
    let stationName: String
    let subtitle: String?
    let rightTopText: String
    let leftBottomText: String
    let middleBottomText: String
    let rightBottomText: String
}

#Preview {
    let sampleStations = [
        StationData(
            logoName: "RZHD",
            stationName: "РЖД",
            subtitle: "С пересадкой в Костроме",
            rightTopText: "16 января",
            leftBottomText: "22:30",
            middleBottomText: "9 часов",
            rightBottomText: "22:30"
        ),
        StationData(
            logoName: "FGK",
            stationName: "ФГК",
            subtitle: nil,
            rightTopText: "16 января",
            leftBottomText: "00:10",
            middleBottomText: "8 часов",
            rightBottomText: "08:10"
        ),
        StationData(
            logoName: "YRAL",
            stationName: "Урал логистика",
            subtitle: "С пересадкой в Ростове",
            rightTopText: "16 января",
            leftBottomText: "06:30",
            middleBottomText: "10 часов",
            rightBottomText: "16:30"
        ),
        StationData(
            logoName: "RZHD",
            stationName: "РЖД",
            subtitle: nil,
            rightTopText: "16 января",
            leftBottomText: "12:00",
            middleBottomText: "7 часов",
            rightBottomText: "19:00"
        ),
        StationData(
            logoName: "RZHD",
            stationName: "РЖД",
            subtitle: "С пересадкой в Тюмени",
            rightTopText: "16 января",
            leftBottomText: "14:00",
            middleBottomText: "6 часов",
            rightBottomText: "20:00"
        )
    ]

    StationsScreenView(
        headerText: "Москва (Ярославский вокзал) → Санкт-Петербург (Балтийский вокзал)",
        stations: sampleStations
    )
}
