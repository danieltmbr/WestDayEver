import Foundation

public protocol NetworkRequestLoader {
    associatedtype R: NetworkRequest
    
    func fetch(with params: R.RequestDataType) async throws -> R.ResponseDataType
}

public extension NetworkRequestLoader where R.RequestDataType == Void {
    func fetch() async throws -> R.ResponseDataType {
        try await fetch(with: ())
    }
}

public actor RequestLoader<Request: NetworkRequest>: NetworkRequestLoader {
    public typealias R = Request
    
    private let session: URLSession
    private let request: Request
    
    public init(
        session: URLSession = .shared,
        request: Request
    ) {
        self.session = session
        self.request = request
    }
    
    public func fetch(with params: Request.RequestDataType) async throws -> Request.ResponseDataType {
        let urlRequest = try request.makeRequest(from: params)
        let (data, response) = try await session.data(for: urlRequest)
        return try request.parseResponse(data: data, response: response)
    }
}
