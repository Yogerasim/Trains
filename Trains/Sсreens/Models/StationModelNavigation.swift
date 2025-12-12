import Foundation

struct FilterNav: Hashable {}

struct InfoNav: Hashable {
    let carrierName: String
    let imageName: String
    let info: [InfoItem]
}

struct InfoItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
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

struct Station: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let city: String
}

struct City: Identifiable, Hashable, Codable{
    var id = UUID()
    let name: String
    let stations: [StationInfo]
}

struct StationInfo: Hashable, Codable{
    let title: String
    let code: String
}
