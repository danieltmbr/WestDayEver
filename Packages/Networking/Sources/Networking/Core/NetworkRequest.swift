import Foundation

public protocol NetworkRequest {
    associatedtype RequestDataType
    associatedtype ResponseDataType: Decodable
    func makeRequest(from data: RequestDataType) throws -> URLRequest
    func parseResponse(data: Data, response: URLResponse) throws -> ResponseDataType
}

public extension NetworkRequest where RequestDataType == Void {
    func makeRequest() throws -> URLRequest {
        try makeRequest(from: ())
    }
}
