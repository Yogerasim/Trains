import Foundation

struct StationData: Identifiable, Equatable {
    let id = UUID()
    let carrierCode: String?
    let logoURL: URL?
    let stationName: String
    let subtitle: String?
    let rightTopText: String
    let leftBottomText: String
    let middleBottomText: String
    let rightBottomText: String
    let departureDate: Date?
    let hasTransfers: Bool
}
