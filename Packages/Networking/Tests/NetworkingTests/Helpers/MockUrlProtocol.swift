import Foundation

final public class MockUrlProtocol: URLProtocol {

    public static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override public func startLoading() {
        guard let handler = MockUrlProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override public func stopLoading() {
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override public class func canInit(with request: URLRequest) -> Bool {
        true
    }
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
}
