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

//    static let stationCards: [StationData] = [
//        StationData(
//            carrierCode: carrier?.code.map { String($0) },
//            logoURL: URL(string: "https://yastat.net/s3/rasp/media/data/company/logo/logo.gif"),
//            stationName: "РЖД",
//            subtitle: "С пересадкой в Костроме",
//            rightTopText: "16 января",
//            leftBottomText: "22:30",
//            middleBottomText: "9 часов",
//            rightBottomText: "22:30"
//        )
//    ]

    static let infoItems: [InfoItem] = [
        InfoItem(title: "Телефон", subtitle: "+7 (904) 329-27-71"),
        InfoItem(title: "Email", subtitle: "i.lozgkina@yandex.ru"),
    ]
}
