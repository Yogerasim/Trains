import Foundation

struct City: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let stations: [StationInfo]
}
