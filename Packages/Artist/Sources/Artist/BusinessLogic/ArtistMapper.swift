import Foundation

struct ArtistMappingError: Error {
    enum Attr {
        case id, born
    }
    
    let attr: Attr
    let content: String
}

let artistMapper: (ArtistDTO) throws -> Artist = { dto in
    guard let id = Int(dto.idArtist) else {
        throw ArtistMappingError(attr: .id, content: dto.idArtist)
    }
    guard let born = Int(dto.intBornYear) else {
        throw ArtistMappingError(attr: .born, content: dto.intBornYear)
    }
    return Artist(
        id: ArtistId(id),
        name: dto.strArtist,
        born: born,
        genre: dto.strGenre,
        label: dto.strLabel,
        website: dto.strWebsite,
        biography: dto.strBiographyEN,
        country: dto.strCountry,
        thumbnail: dto.strArtistThumb
    )
}
