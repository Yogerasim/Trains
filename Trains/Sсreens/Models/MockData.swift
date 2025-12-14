import Foundation

enum MockData {
    static let cities = [
        "Москва",
        "Санкт-Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск",
    ]

    static let stations = [
        "Казанский вокзал",
        "Ладожский вокзал",
        "Ярославский вокзал",
        "Витебский вокзал",
        "Левобережная",
    ]

    static let stationCards: [StationData] = [
        StationData(
            logoURL: nil,
            logoName: "RZHD",
            stationName: "РЖД",
            subtitle: "С пересадкой в Костроме",
            rightTopText: "16 января",
            leftBottomText: "22:30",
            middleBottomText: "9 часов",
            rightBottomText: "22:30"
        ),
        StationData(
            logoURL: nil,
            logoName: "FGK",
            stationName: "ФГК",
            subtitle: nil,
            rightTopText: "16 января",
            leftBottomText: "00:10",
            middleBottomText: "8 часов",
            rightBottomText: "08:10"
        ),
    ]

    static let infoItems: [InfoItem] = [
        InfoItem(title: "Телефон", subtitle: "+7 (904) 329-27-71"),
        InfoItem(title: "Email", subtitle: "i.lozgkina@yandex.ru"),
    ]
}
