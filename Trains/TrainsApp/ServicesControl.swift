import Foundation
import Combine

final class ServicesControl: ObservableObject {

    static let shared = ServicesControl()

    @Published var runTests: Bool = true

    @Published var stationsList: Bool = false
    @Published var nearestStations: Bool = false
    @Published var scheduleOnStation: Bool = false
    @Published var threadService: Bool = true
    @Published var ridesBetweenStations: Bool = false
    @Published var nearestSettlement: Bool = false
    @Published var carrierInfo: Bool = false
    @Published var copyright: Bool = false

    private init() {}
}
