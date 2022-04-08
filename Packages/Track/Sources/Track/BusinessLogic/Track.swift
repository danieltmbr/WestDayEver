import Foundation

public typealias TrackId = Int

public struct Track: Identifiable, Equatable {
    public let id: TrackId
    public let title: String
    public let album: String
    public let artist: String
    public let duration: TimeInterval
    public let trackNumber: Int
}

// MARK: - Sample data

extension Track {
    static let saintPablo = Track(
        id: 1,
        title: "Saint Pablo",
        album: "The life of Pablo",
        artist: "Kanye West",
        duration: 300,
        trackNumber: 19
    )
}

extension Array where Element == Track {
    static let kanye = [Track.saintPablo]
}
