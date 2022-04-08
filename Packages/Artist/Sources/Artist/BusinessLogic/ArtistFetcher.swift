import Foundation
import Networking
import Storage
import Fetcher

typealias ArtistFetcher = FetchLocalFirst<ArtistId, Artist>

extension ArtistFetcher {
    static var `default`: ArtistFetcher {
        FetchLocalFirst(
            remote: RequestLoader(request: ArtistRequest()),
            local: CodableStorage(directory: "artist"),
            mapper: artistMapper
        )
    }
}

extension CodableStorage: LocalSource {}
extension RequestLoader: RemoteSource {}


//public protocol Fetcher {
//    func artist(with id: ArtistId) -> AsyncThrowingStream<Artist, Error>
//}
//
//struct ArtistFetcher<RemoteSource, LocalSource>: Fetcher
//where RemoteSource: NetworkRequestLoader, RemoteSource.R == ArtistRequest,
//      LocalSource: Storage, LocalSource.Key == ArtistId, LocalSource.Value == ArtistDTO {
//    
//    private let loader: RemoteSource
//    private let storage: LocalSource
//    private let mapper: (ArtistDTO) throws -> Artist
//    
//    init(
//        loader: RemoteSource,
//        storage: LocalSource,
//        mapper: @escaping (ArtistDTO) throws -> Artist = artistMapper
//    ) {
//        self.loader = loader
//        self.storage = storage
//        self.mapper = mapper
//    }
//    
//    func artist(with id: ArtistId) -> AsyncThrowingStream<Artist, Error> {
//        AsyncThrowingStream { continuation in
//            Task {
//                // Try to fetch local data first to get data asap
//                await self.fetchLocal(with: id, continuation: continuation)
//                // Then refresh and update with remote data
//                await self.fetchRemote(with: id, continuation: continuation)
//            }
//        }
//    }
//    
//    private func fetchLocal(
//        with artistId: ArtistId,
//        continuation: AsyncThrowingStream<Artist, Error>.Continuation
//    ) async {
//        if let localArtist = try? await storage.load(with: artistId) {
//            do {
//                let artist = try mapper(localArtist)
//                continuation.yield(artist)
//            } catch {
//                // If parsing fails the data might be in an
//                // outdated format, so we clear the storage
//                try? await storage.clear(with: artistId)
//            }
//        }
//    }
//    
//    private func fetchRemote(
//        with artistId: ArtistId,
//        continuation: AsyncThrowingStream<Artist, Error>.Continuation
//    ) async {
//        do {
//            let remoteArtist = try await loader.fetch(with: artistId)
//            let artist = try mapper(remoteArtist)
//            
//            Task.detached(priority: .background) {
//                // We let the storage fail silently, it's still logged
//                try? await self.storage.save(remoteArtist, with: artistId)
//            }
//            
//            continuation.yield(artist)
//            continuation.finish()
//        } catch {
//            continuation.finish(throwing: error)
//        }
//    }
//}
//
//extension ArtistFetcher
//where RemoteSource == RequestLoader<ArtistRequest>,
//      LocalSource == CodableStorage<ArtistId, ArtistDTO, PropertyListEncoder, PropertyListDecoder> {
//    
//    static var `default`: ArtistFetcher {
//        ArtistFetcher(
//            loader: RequestLoader(request: ArtistRequest()),
//            storage: CodableStorage.artist
//        )
//    }
//}
//
//extension CodableStorage
//where Key == ArtistId, Value == ArtistDTO,
//      Encoder == PropertyListEncoder, Decoder == PropertyListDecoder {
//    static let artist = CodableStorage(directory: "artist")
//}
//
//struct StubFetcher: Fetcher {
//    func artist(with id: ArtistId) -> AsyncThrowingStream<Artist, Error> {
//        AsyncThrowingStream {
//            return Artist.kanye
//        }
//    }
//}
