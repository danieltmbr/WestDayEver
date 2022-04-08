import Foundation
import Networking

struct TracksRequest: NetworkRequest {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    func makeRequest(from albumId: AlbumId) throws -> URLRequest {
        guard let url = URL(string: "https://theaudiodb.com/api/v1/json/2/track.php?m=\(albumId)") else {
            // Since the URL is hardcoded, and an Int query item is always "url encoded"
            // the components initialiser would only fail if there was a human error
            // involved from a developer. So we fail early, we could also throw an error though.
            fatalError("Malformed URL")
        }
        var request = URLRequest.get(url: url)
        request.addHeaderField(ContentType.json)
        return request
    }
    
    func parseResponse(data: Data, response: URLResponse) throws -> [TrackDTO] {
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            // TODO: Handle server errors properly
            throw URLError(.badServerResponse)
        }
        let tracksDto = try decoder.decode(TracksDTO.self, from: data)
        return tracksDto.track
    }
}
