import Foundation
import Networking

struct ArtistRequest: NetworkRequest {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    func makeRequest(from artistId: ArtistId) throws -> URLRequest {
        guard let url = URL(string: "https://theaudiodb.com/api/v1/json/2/artist.php?i=\(artistId)") else {
            // Since the URL is hardcoded, and an Int query item is always "url encoded"
            // the components initialiser would only fail if there was a human error
            // involved from a developer. So we fail early, we could also throw an error though.
            fatalError("Malformed URL")
        }
        var request = URLRequest.get(url: url)
        request.addHeaderField(ContentType.json)
        return request
    }
    
    func parseResponse(data: Data, response: URLResponse) throws -> ArtistDTO {
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            // TODO: Handle server errors properly
            throw URLError(.badServerResponse)
        }
        let artists = try decoder.decode(ArtistsDTO.self, from: data)
        guard let artist = artists.artists.first else {
            throw URLError(.badServerResponse, userInfo: ["Content":"Missing artist"])
        }
        return artist
    }
}
