import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            let client = APIConfig.client
            let apikey = APIConfig.apiKey
            guard APIConfig.runTests else {
                    print("✅ Test requests disabled")
                    return
                }

            NearestStationsService(client: client, apikey: apikey).testFetchStations()
            ScheduleOnStationService(client: client, apikey: apikey).testFetchSchedule()
            ThreadService(client: client, apikey: apikey).testFetchThread(station: "s9602494")
            RidesBetweenStationsService(client: client, apikey: apikey).testFetchRides()
            NearestSettlementService().testFetchNearestSettlement()
            CarrierInfoService().testFetchCarrier(code: "TK")
            StationsListService().testFetchStationsList(limitToOneCountry: true)
            CopyrightService().testFetchCopyright()
        }
    }
}

#Preview {
    ContentView()
}
