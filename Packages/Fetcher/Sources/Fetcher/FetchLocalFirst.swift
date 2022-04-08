import Foundation

public protocol RemoteSource {
    associatedtype Parameters
    associatedtype Model
    
    func fetch(with params: Parameters) async throws -> Model
}

public protocol LocalSource {
    associatedtype Parameters
    associatedtype Model
    
    func save(_ value: Model, with key: Parameters) async throws
    
    func load(with key: Parameters) async throws -> Model?
    
    func clear(with key: Parameters) async throws
}

public struct FetchLocalFirst<Parameters, Model>: Fetcher {
    public typealias Stream = AsyncThrowingStream<Model, Error>
    
    private let fetch: (_ params: Parameters) -> Stream
    
    init(_ fetch: @escaping (Parameters) -> Stream) {
        self.fetch = fetch
    }
    
    init(
        fetchLocal: @escaping (Parameters) async throws -> Model?,
        fetchRemote: @escaping (Parameters) async throws -> Model
    ) {
        self.fetch = { params in
            AsyncThrowingStream { continuation in
                Task {
                    do {
                        // Try to fetch local data first to get data asap
                        if let local = try await fetchLocal(params) {
                            continuation.yield(local)
                        }
                        
                        // Then refresh and update with remote data
                        continuation.yield(try await fetchRemote(params))
                        
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }
        }
    }
        
    public init<Remote, Local>(
        remote: Remote,
        local: Local,
        mapper: @escaping (Remote.Model) throws -> Model
    )
    where Remote: RemoteSource, Local: LocalSource,
    Remote.Parameters == Parameters, Local.Parameters == Parameters,
    Remote.Model == Local.Model
    {
        self.init(
            fetchLocal: { params in
                do {
                    guard let localValue = try await local.load(with: params) else { return nil }
                    return try mapper(localValue)
                } catch {
                    Task.detached(priority: .background) {
                        // If parsing fails the data might be in an outdated format, so we clear the storage
                        try? await local.clear(with: params)
                    }
                    // TODO: log error
                    return nil
                }
            },
            fetchRemote: { params in
                let remoteValue = try await remote.fetch(with: params)
                Task.detached(priority: .background) {
                    // We let the storage fail silently, it's still logged
                    try? await local.save(remoteValue, with: params)
                }
                return try mapper(remoteValue)
            }
        )
    }
    
    public func fetch(with params: Parameters) -> Stream {
        fetch(params)
    }
}
