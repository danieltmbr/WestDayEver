import Foundation
import SwiftUI
import Networking
import Storage
import Fetcher
import DesignKit

public typealias AlbumsModel = ViewModel<[Album]>

extension AlbumsModel {
    public static let kanye = AlbumsModel(placeholder: .placeholder) {
        AlbumsFetcher
            .default
            .fetch(with: .kanyeId)
            .map { albums in
                albums.sorted { $0.released > $1.released }
            }
    }

    static let stubbed = AlbumsModel(placeholder: .placeholder) {
        StubbedFetcher([Album].kanye).fetch(with: ArtistId.kanyeId)
    }
}

private extension Album {
    static var placeholder: Album {
        Album(
            id: UUID().hashValue,
            artist: "Placeholder artist",
            title: "Placeholder title",
            released: 2000,
            genre: "Placeholder genre",
            artwork: URL(string: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")!,
            description: "Placeholder description"
        )
    }
}

private extension Array where Element == Album {
    static var placeholder: [Album] {
        (0..<8).map { _ in Album.placeholder }
    }
}
