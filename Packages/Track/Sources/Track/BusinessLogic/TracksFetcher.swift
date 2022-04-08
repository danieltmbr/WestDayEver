import Foundation
import Networking
import Storage
import Fetcher

typealias TracksFetcher = FetchLocalFirst<AlbumId, [Track]>

extension TracksFetcher {
    static var `default`: TracksFetcher {
        FetchLocalFirst(
            remote: RequestLoader(request: TracksRequest()),
            local: CodableStorage(directory: "tracks"),
            mapper: tracksMapper
        )
    }
}

extension CodableStorage: LocalSource {}
extension RequestLoader: RemoteSource {}

//public protocol Fetcher {
//    func tracks(for albumId: Int) -> AsyncThrowingStream<[Track], Error>
//}
//
//struct TracksFetcher<RemoteSource, LocalSource>: Fetcher
//where RemoteSource: NetworkRequestLoader, RemoteSource.R == TracksRequest,
//      LocalSource: Storage, LocalSource.Key == AlbumId, LocalSource.Value == [TrackDTO] {
//
//    private let loader: RemoteSource
//    private let storage: LocalSource
//    private let mapper: ([TrackDTO]) throws -> [Track]
//
//    init(
//        loader: RemoteSource,
//        storage: LocalSource,
//        mapper: @escaping ([TrackDTO]) throws -> [Track] = tracksMapper
//    ) {
//        self.loader = loader
//        self.storage = storage
//        self.mapper = mapper
//    }
//
//    func tracks(for albumId: Int) -> AsyncThrowingStream<[Track], Error> {
//        AsyncThrowingStream { continuation in
//            Task {
//                // Try to fetch local data first to get data asap
//                await self.fetchLocal(for: albumId, continuation: continuation)
//                // Then refresh and update with remote data
//                await self.fetchRemote(for: albumId, continuation: continuation)
//            }
//        }
//    }
//
//    private func fetchLocal(
//        for albumId: AlbumId,
//        continuation: AsyncThrowingStream<[Track], Error>.Continuation
//    ) async {
//        if let localTracks = try? await storage.load(with: albumId) {
//            do {
//                let tracks = try mapper(localTracks)
//                continuation.yield(tracks)
//            } catch {
//                // If parsing fails the data might be in an
//                // outdated format, so we clear the storage
//                try? await storage.clear(with: albumId)
//            }
//        }
//    }
//
//    private func fetchRemote(
//        for albumId: AlbumId,
//        continuation: AsyncThrowingStream<[Track], Error>.Continuation
//    ) async {
//        do {
//            let remoteTracks = try await loader.fetch(with: albumId)
//            let tracks = try mapper(remoteTracks)
//
//            Task.detached(priority: .background) {
//                // We let the storage fail silently, it's still logged
//                try? await self.storage.save(remoteTracks, with: albumId)
//            }
//
//            continuation.yield(tracks)
//            continuation.finish()
//        } catch {
//            print(error)
//            continuation.finish(throwing: error)
//        }
//    }
//}
//
//extension TracksFetcher
//where RemoteSource == RequestLoader<TracksRequest>,
//      LocalSource == CodableStorage<AlbumId, [TrackDTO], PropertyListEncoder, PropertyListDecoder>{
//
//    static var `default`: TracksFetcher {
//        TracksFetcher(
//            loader: RequestLoader(request: TracksRequest()),
//            storage: CodableStorage(directory: "tracks")
//        )
//    }
//}
//
//struct StubFetcher: Fetcher {
//    func tracks(for albumId: Int) -> AsyncThrowingStream<[Track], Error> {
//        AsyncThrowingStream {
//            return [Track].kanye
//        }
//    }
//}
