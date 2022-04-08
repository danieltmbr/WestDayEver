import Foundation
import SwiftUI
import Networking
import Storage
import Fetcher
import DesignKit

public typealias ArtistModel = ViewModel<Artist>

extension ArtistModel {
    public static let kanye = ArtistModel(placeholder: .placeholder) {
        ArtistFetcher
            .default
            .fetch(with: .kanyeId)
    }

    static let stubbed = ArtistModel(placeholder: .placeholder) {
        StubbedFetcher(Artist.kanye).fetch(with: ArtistId.kanyeId)
    }
}

private extension Artist {
    static let placeholder = Artist(
        id: .placeholderArtistId,
        name: "Placeholder Artist",
        born: 2000,
        genre: "Placeholder genre",
        label: "Placeholder label",
        website: URL(string: "https://www.google.com")!,
        biography: "Placeholder biography",
        country: "Placeholder country",
        thumbnail: URL(string: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")!
    )
}

//public final class ArtistModel: ObservableObject {
//
//    // MARK:  -
//    struct Data {
//        enum Kind { case placeholder, real }
//
//        let kind: Kind
//        let artist: Artist
//
//        init(artist: Artist) {
//            self.init(kind: .real, artist: artist)
//        }
//
//        private init(kind: Kind, artist: Artist) {
//            self.kind = kind
//            self.artist = artist
//        }
//
//        static let placeholder = Self(kind: .placeholder, artist: .placeholder)
//    }
//
//    // MARK: -
//
//    @Published
//    private(set) var data: Data = .placeholder
//
//    // Conveneience
//    private var artist: Artist {
//        get { data.artist }
//        set { data = Data(artist: newValue) }
//    }
//
//    @Published
//    var error: String?
//
//    @Published
//    private(set) var isLoading: Bool = false
//
//    private let artistId: ArtistId
//
//    private let fetcher: any Fetcher
//
//    init(fetcher: Fetcher, artistId: ArtistId) {
//        self.fetcher = fetcher
//        self.artistId = artistId
//    }
//
//    @MainActor
//    func loadArtist() async {
//        error = nil
//        isLoading = true
//        do {
//            for try await artist in fetcher.artist(with: artistId) where self.artist != artist {
//                self.artist = artist
//            }
//        } catch {
//            // TODO: Log error
//            self.error = data.kind == .placeholder
//                ? "Couldn't load content. Try again later."
//                : "The content might be outdated as refreshing wasn't successful."
//        }
//        isLoading = false
//    }
//}
//
//extension ArtistModel {
//    public static let kanye = ArtistModel(fetcher: ArtistFetcher.default, artistId: .kanyeId)
//    static let stubbed = ArtistModel(fetcher: StubFetcher(), artistId: .placeholderArtistId)
//}
