import Foundation

struct ArtistDTO: Codable, Equatable {
    let idArtist: String
    let strArtist: String
    let strLabel: String
    let intBornYear: String
    let strGenre: String
    let strWebsite: URL
    let strBiographyEN: String
    let strCountry: String
    let strArtistThumb: URL
}

struct ArtistsDTO: Decodable {
    let artists: [ArtistDTO]
}
