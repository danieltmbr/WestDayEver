import Foundation

public typealias ArtistId = Int

public struct Artist: Identifiable, Equatable {
    public let id: ArtistId
    public let name: String
    public let born: Int
    public let genre: String
    public let label: String
    public let website: URL
    public let biography: String
    public let country: String
    public let thumbnail: URL
}

// MARK: - Sample data

extension ArtistId {
    static let kanyeId = 111822
    static let placeholderArtistId = 0
}

extension Artist {
    static let kanye = Artist(
        id: .kanyeId,
        name: "Kanye West",
        born: 1977,
        genre: "Hip-Hop",
        label: "Rock-A-Fella",
        website: URL(string: "https://www.kanyewest.com")!,
        biography: "",
        country: "USA",
        thumbnail: URL(string: "https://www.theaudiodb.com/images/media/artist/thumb/wttxqu1435514924.jpg")!
    )
}
