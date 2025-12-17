import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(from: String, to: String, date: String?) async throws -> Segments
}

actor SearchService: SearchServiceProtocol {

    private let apikey: String
    private let client: Client

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?
    ) async throws -> Segments {

        var components = URLComponents(string: "https://api.rasp.yandex.net/v3.0/search/")!
        components.queryItems = [
            .init(name: "apikey", value: apikey),
            .init(name: "from", value: from),
            .init(name: "to", value: to),
            date.map { .init(name: "date", value: $0) }
        ].compactMap { $0 }

        let (data, _) = try await URLSession.shared.data(from: components.url!)

        return try YandexJSONDecoder.shared.decode(Segments.self, from: data)
    }
}
