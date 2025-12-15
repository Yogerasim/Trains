import Foundation
import SwiftUI

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

    static let infoItems: [InfoItem] = [
        InfoItem(title: "Телефон", subtitle: "+7 (904) 329-27-71"),
        InfoItem(title: "Email", subtitle: "i.lozgkina@yandex.ru"),
    ]
}
