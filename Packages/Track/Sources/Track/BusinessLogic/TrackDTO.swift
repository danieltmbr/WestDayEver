import Foundation

struct TrackDTO: Codable, Equatable {
    let idTrack: String
    let strTrack: String
    let strAlbum: String
    let strArtist: String
    let intDuration: String
    let intTrackNumber: String
}

struct TracksDTO: Decodable {
    let track: [TrackDTO]
}
