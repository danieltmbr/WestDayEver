import Foundation

struct AlbumDTO: Codable, Equatable {
    let idAlbum: String
    let strAlbum: String
    let strArtist: String
    let intYearReleased: String
    let strGenre: String?
    let strAlbumThumb: URL
    let strDescriptionEN: String?
}

struct AlbumsDTO: Decodable {
    let album: [AlbumDTO]
}
