import Foundation
import HTTPTypes
import OpenAPIRuntime
import OpenAPIURLSession

struct HTMLJSONTransport: ClientTransport, Sendable {
    private let underlying: ClientTransport

    init(underlying: ClientTransport = URLSessionTransport()) {
        self.underlying = underlying
    }

    func send(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var (response, responseBody) = try await underlying.send(
            request,
            body: body,
            baseURL: baseURL,
            operationID: operationID
        )

        if let contentType = response.headerFields[.contentType],
           contentType.lowercased().hasPrefix("text/html")
        {
            response.headerFields[.contentType] = "application/json; charset=utf-8"
        }

        return (response, responseBody)
    }
}
