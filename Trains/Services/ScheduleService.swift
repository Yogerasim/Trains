import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getStationSchedule(station: String, date: String?) async throws -> ScheduleResponse
}

final class ScheduleService: ScheduleServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationSchedule(station: String, date: String?) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            date: date
        ))
        return try response.ok.body.json
    }
}

