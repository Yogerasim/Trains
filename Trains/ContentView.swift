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
            let client = Client(
                serverURL: (try? Servers.Server1.url()) ?? URL(string: "https://example.com")!,
                transport: URLSessionTransport()
            )

            let nearestService = NearestStationsService(client: client, apikey: "358e8b9d-a92c-4b0b-a840-9ca909f976d8")
            nearestService.testFetchStations()

            let scheduleService = ScheduleOnStationService(client: client, apikey: "358e8b9d-a92c-4b0b-a840-9ca909f976d8")
            scheduleService.testFetchSchedule()

            let threadService = ThreadService(client: client, apikey: "358e8b9d-a92c-4b0b-a840-9ca909f976d8")
            threadService.testFetchThread(station: "s9602494") // Московский вокзал СПбм
            let ridesService = RidesBetweenStationsService(
                client: client,
                apikey: "358e8b9d-a92c-4b0b-a840-9ca909f976d8"
            )
            ridesService.testFetchRides()
        }
    }
}

#Preview {
    ContentView()
}
