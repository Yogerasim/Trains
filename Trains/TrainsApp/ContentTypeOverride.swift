import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import HTTPTypes

/// A transport that wraps URLSessionTransport and fixes misreported Content-Type headers.
/// If the server responds with "text/html" while the body is actually JSON, we rewrite it to "application/json".
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
           contentType.lowercased().hasPrefix("text/html") {
            // Force JSON decoding downstream.
            response.headerFields[.contentType] = "application/json; charset=utf-8"
        }

        return (response, responseBody)
    }
}

