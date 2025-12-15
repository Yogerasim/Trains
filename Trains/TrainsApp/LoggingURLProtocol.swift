import Foundation

final class LoggingURLProtocol: URLProtocol, URLSessionDataDelegate {
    private static var isRegistered = false

    private var dataTask: URLSessionDataTask?
    private var responseData = Data()
    private var response: URLResponse?

    static func registerIfNeeded() {
        guard !isRegistered else { return }
        URLProtocol.registerClass(LoggingURLProtocol.self)
        isRegistered = true
        print("✅ LoggingURLProtocol registered")
    }

    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "LoggingURLProtocolHandled", in: request) != nil {
            return false
        }
        guard let scheme = request.url?.scheme?.lowercased() else { return false }
        return scheme == "http" || scheme == "https"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let mutableReq = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            logRequest(request)
            dataTask = session.dataTask(with: request)
            dataTask?.resume()
            return
        }

        URLProtocol.setProperty(true, forKey: "LoggingURLProtocolHandled", in: mutableReq)

        let req = mutableReq as URLRequest

        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        logRequest(req)
        dataTask = session.dataTask(with: req)
        dataTask?.resume()
    }

    override func stopLoading() {
        dataTask?.cancel()
        dataTask = nil
    }

    func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
        responseData.append(data)
    }

    func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError error: Error?) {
        if let error {
            client?.urlProtocol(self, didFailWithError: error)
            print("❌ Network error: \(error)")
        } else {
            if let resp = response {
                client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed)
            }
            client?.urlProtocolDidFinishLoading(self)
            logResponse()
        }
    }

    func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.response = response
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }

    private func logRequest(_ request: URLRequest) {
        print("\n--- HTTP REQUEST ---")
        if let method = request.httpMethod, let url = request.url?.absoluteString {
            print("➡️ \(method) \(url)")
        } else {
            print("➡️ Request: \(request)")
        }
        if let headers = request.allHTTPHeaderFields {
            print("➡️ Headers: \(headers)")
        }
        if let body = request.httpBody, body.count > 0 {
            if let str = String(data: body, encoding: .utf8) {
                print("➡️ Body: \(str)")
            } else {
                print("➡️ Body: <binary \(body.count) bytes>")
            }
        }
        print("--------------------\n")
    }

    private func logResponse() {
        print("\n--- HTTP RESPONSE ---")
        if let httpResp = response as? HTTPURLResponse {
            print("⬅️ Status: \(httpResp.statusCode)")
            print("⬅️ URL: \(httpResp.url?.absoluteString ?? "nil")")
            print("⬅️ Headers: \(httpResp.allHeaderFields)")
        } else {
            print("⬅️ Response: \(String(describing: response))")
        }

        if responseData.count > 0 {
            if let s = String(data: responseData, encoding: .utf8) {
                if s.count > 20000 {
                    let start = s.prefix(20000)
                    print("⬅️ Body (truncated):\n\(start)\n...truncated...")
                } else {
                    print("⬅️ Body:\n\(s)")
                }
            } else {
                print("⬅️ Body: <binary \(responseData.count) bytes>")
            }
        } else {
            print("⬅️ Body: <empty>")
        }
        print("---------------------\n")
    }
}
