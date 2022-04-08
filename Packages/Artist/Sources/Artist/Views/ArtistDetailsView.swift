import SwiftUI
import DesignKit

struct ArtistDetailsView: View {
    let born: String
    let hometown: String
    let genre: String
    let biography: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: .vSpacing.item) {
            DetailItemView {
                Text("Born", comment: "Year label for artist details")
            } value: {
                Text(verbatim: born)
            }
            
            DetailItemView {
                Text("Hometown", comment: "Hometown label for artist details")
            } value: {
                Text(verbatim: hometown)
            }
            
            DetailItemView {
                Text("Genre", comment: "Genre label for artist details")
            } value: {
                Text(verbatim: genre)
            }
            
            DetailItemView {
                Text("Biography", comment: "Biography label for artist detail")
            } value: {
                Text(verbatim: biography)
            }
        }
    }
}

extension ArtistDetailsView {
    init(artist: Artist) {
        self.init(
            born: "\(artist.born)",
            hometown: artist.country,
            genre: artist.genre,
            biography: artist.biography
        )
    }
}


struct ArtistDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailsView(artist: .kanye)
    }
}
