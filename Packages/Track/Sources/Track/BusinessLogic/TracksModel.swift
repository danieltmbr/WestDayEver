import Foundation
import SwiftUI
import Networking
import Storage
import Fetcher
import DesignKit

public typealias TracksModel = ViewModel<[Track]>

extension TracksModel {
    public static func `default`(for albumId: AlbumId) -> TracksModel {
        TracksModel(placeholder: .placeholder) {
            TracksFetcher
                .default
                .fetch(with: albumId)
                .map { tracks in
                    tracks.sorted { $0.trackNumber < $1.trackNumber }
                }
        }
    }

    public static let stubbed = TracksModel(placeholder: .placeholder) {
        StubbedFetcher([Track].kanye).fetch(with: AlbumId.tlopId)
    }
}

private extension Track {
    static var placeholder: Track {
        Track(
            id: UUID().hashValue,
            title: "Placeholder title",
            album: "Placeholder album",
            artist: "Placeholder artist",
            duration: 300,
            trackNumber: 1
        )
    }
}

private extension Array where Element == Track {
    static var placeholder: [Track] {
        (0..<8).map { _ in Track.placeholder }
    }
}

//
//public final class TracksModel: ObservableObject {
//
//    // MARK:  -
//    public struct Data {
//        public enum Kind { case placeholder, real }
//
//        public let kind: Kind
//        public let tracks: [Track]
//
//        init(tracks: [Track]) {
//            self.init(kind: .real, tracks: tracks)
//        }
//
//        private init(kind: Kind, tracks: [Track]) {
//            self.kind = kind
//            self.tracks = tracks
//        }
//
//        static let placeholder = Self(kind: .placeholder, tracks: .placeholder)
//    }
//
//    // MARK: -
//
//    @Published
//    public private(set) var data: Data = .placeholder
//
//    private var tracks: [Track] {
//        get { data.tracks }
//        set { data = Data(tracks: newValue) }
//    }
//
//    @Published
//    public var error: String?
//
//    @Published
//    public private(set) var isLoading: Bool = false
//
//    private let albumId: Int
//
//    private let fetcher: any Fetcher
//
//    init(fetcher: Fetcher, albumId: Int) {
//        self.albumId = albumId
//        self.fetcher = fetcher
//    }
//
//    @MainActor
//    public func loadTracks() async {
//        error = nil
//        isLoading = true
//        do {
//            for try await tracks in fetcher.tracks(for: albumId) where self.tracks != tracks {
//                self.tracks = tracks.sorted { $0.trackNumber < $1.trackNumber }
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
//extension TracksModel {
//    public static func `default`(with albumId: AlbumId) -> TracksModel {
//        TracksModel(fetcher: TracksFetcher.default, albumId: albumId)
//    }
//    static let stubbed = TracksModel(fetcher: StubFetcher(), albumId: .placeholderAlbumId)
//}
//
