import Foundation

public struct StubbedFetcher<Parameters, Model>: Fetcher {
    public typealias Stream = AsyncThrowingStream<Model, Error>
    
    private let fetch: (_ params: Parameters) -> Stream
    
    public init(fetch: @escaping (Parameters) -> StubbedFetcher<Parameters, Model>.Stream) {
        self.fetch = fetch
    }
    
    public init(_ model: Model) {
        self.init { _ in
            AsyncThrowingStream { continuation in
                continuation.yield(model)
                continuation.finish()
            }
        }
    }
    
    public init(error: Error) {
        self.init { _ in
            AsyncThrowingStream { continuation in
                continuation.finish(throwing: error)
            }
        }
    }
    
    public func fetch(with params: Parameters) -> Stream {
        fetch(params)
    }
}
