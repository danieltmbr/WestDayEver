import Foundation
import Networking
import Storage
import Fetcher

typealias AlbumsFetcher = FetchLocalFirst<ArtistId, [Album]>

extension AlbumsFetcher {
    static var `default`: AlbumsFetcher {
        FetchLocalFirst(
            remote: RequestLoader(request: AlbumsRequest()),
            local: CodableStorage(directory: "albums"),
            mapper: albumsMapper
        )
    }
}

extension CodableStorage: LocalSource {}
extension RequestLoader: RemoteSource {}
