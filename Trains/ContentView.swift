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
            guard APIConfig.runTests else {
                print("✅ Test requests disabled")
                return
            }

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
}

#Preview {
    ContentView()
}
