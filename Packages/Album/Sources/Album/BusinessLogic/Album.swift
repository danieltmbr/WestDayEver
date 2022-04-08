import Foundation
import Accessibility

public typealias AlbumId = Int

public struct Album: Identifiable, Equatable {
    public let id: AlbumId
    public let artist: String
    public let title: String
    public let released: Int
    public let genre: String
    public let artwork: URL
    public let description: String
}

// MARK: - Sample data

public extension Album {
    static let tlop = Album(
        id: 1,
        artist: "Kanye West",
        title: "The life of Pablo",
        released: 2016,
        genre: "Hip-Hop",
        artwork: URL(string: "https://upload.wikimedia.org/wikipedia/en/4/4d/The_life_of_pablo_alternate.jpg")!,
        description: "The life of Pablo album"
    )
}

extension Array where Element == Album {
    static let kanye = [Album.tlop]
}
