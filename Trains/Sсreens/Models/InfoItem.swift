import Foundation

struct InfoItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
}
