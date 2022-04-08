import Foundation

struct AlbumMappingError: Error {
    enum Attr {
        case id, released
    }
    
    let attr: Attr
    let content: String
}

private let albumMapper: (AlbumDTO) throws -> Album = { dto in
    guard let id = Int(dto.idAlbum) else {
        throw AlbumMappingError(attr: .id, content: dto.idAlbum)
    }
    guard let released = Int(dto.intYearReleased) else {
        throw AlbumMappingError(attr: .released, content: dto.intYearReleased)
    }
    return Album(
        id: id,
        artist: dto.strArtist,
        title: dto.strAlbum,
        released: released,
        genre: dto.strGenre ?? "",
        artwork: dto.strAlbumThumb,
        description: dto.strDescriptionEN ?? ""
    )
}

let albumsMapper: ([AlbumDTO]) throws -> [Album] = { dtos in
    return try dtos.map(albumMapper)
}
