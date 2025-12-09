import Foundation
import Combine

final class AppViewModel: ObservableObject {
    private let services = ServicesControl.shared
    private var cancellables = Set<AnyCancellable>()

    private let client = APIConfig.client
    private let apikey = APIConfig.apiKey

    init() {
        if services.runTests {
            runTests()
        }

        services.$runTests
            .sink { [weak self] run in
                if run {
                    self?.runTests()
                } else {
                    print("Tests disabled")
                }
            }
            .store(in: &cancellables)
    }

    private func runTests() {
        print("Running enabled API tests...")

        if services.stationsList {
            StationsListService(client: client, apikey: apikey)
                .testFetchStationsList(limitToOneCountry: true)
        }
        
        if services.nearestStations {
            NearestStationsService(client: client, apikey: apikey)
                .testFetchStations()
        }

        if services.scheduleOnStation {
            ScheduleOnStationService(client: client, apikey: apikey)
                .testFetchSchedule()
        }

        if services.threadService {
            ThreadService(client: client, apikey: apikey)
                .testFetchThread(station: "s9602494")
        }

        if services.ridesBetweenStations {
            RidesBetweenStationsService(client: client, apikey: apikey)
                .testFetchRides()
        }

        if services.nearestSettlement {
            NearestSettlementService(client: client, apikey: apikey)
                .testFetchNearestSettlement()
        }

        if services.carrierInfo {
            CarrierInfoService()
                .testFetchCarrier(code: "TK")
        }

        if services.copyright {
            CopyrightService(client: client, apikey: apikey)
                .testFetchCopyright()
        }
    }
}
