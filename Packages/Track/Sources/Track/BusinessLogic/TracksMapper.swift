import Foundation

struct TrackMappingError: Error {
    enum Attr {
        case id, duration, trackNumber
    }
    
    let attr: Attr
    let content: String
}

private let trackMapper: (TrackDTO) throws -> Track = { dto in
    guard let id = Int(dto.idTrack) else {
        throw TrackMappingError(attr: .id, content: dto.idTrack)
    }
    guard let duration = TimeInterval(dto.intDuration) else {
        throw TrackMappingError(attr: .duration, content: dto.intDuration)
    }
    guard let trackNumber = Int(dto.intTrackNumber) else {
        throw TrackMappingError(attr: .trackNumber, content: dto.intTrackNumber)
    }
    return Track(
        id: id,
        title: dto.strTrack,
        album: dto.strAlbum,
        artist: dto.strArtist,
        duration: duration / 1000,
        trackNumber: trackNumber
    )
}

let tracksMapper: ([TrackDTO]) throws -> [Track] = { dtos in
    return try dtos.map(trackMapper)
}
