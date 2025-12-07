import Foundation

struct FilterNav: Hashable {}
struct InfoNav: Hashable {
    let carrierName: String
    let imageName: String
    let info: [InfoItem]
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
