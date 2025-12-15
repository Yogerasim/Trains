import Combine
import Foundation

final class ServicesControl: ObservableObject {
    static let shared = ServicesControl()

    @Published var runTests: Bool = true

    @Published var stationsList: Bool = true
    @Published var nearestStationsService: Bool = true
    @Published var scheduleService: Bool = true
    @Published var threadService: Bool = true
    @Published var searchService: Bool = true
    @Published var nearestSettlementService: Bool = true
    @Published var carrierService: Bool = true
    @Published var copyrightService: Bool = true

    private init() {}
}
