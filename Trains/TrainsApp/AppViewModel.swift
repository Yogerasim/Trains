import Combine

final class AppViewModel: ObservableObject {

    init() {
        guard APIConfig.runTests else {
            print("Tests disabled")
            return
        }
        runTests()
    }

    private func runTests() {
        let client = APIConfig.client
        let apikey = APIConfig.apiKey

        NearestStationsService(client: client, apikey: apikey).testFetchStations()
        ScheduleOnStationService(client: client, apikey: apikey).testFetchSchedule()
        ThreadService(client: client, apikey: apikey).testFetchThread(station: "s9602494")
        RidesBetweenStationsService(client: client, apikey: apikey).testFetchRides()
        NearestSettlementService(client: client, apikey: apikey).testFetchNearestSettlement()
        CarrierInfoService().testFetchCarrier(code: "TK")
        StationsListService(client: client, apikey: apikey).testFetchStationsList(limitToOneCountry: true)
        CopyrightService(client: client, apikey: apikey).testFetchCopyright()
    }
}
