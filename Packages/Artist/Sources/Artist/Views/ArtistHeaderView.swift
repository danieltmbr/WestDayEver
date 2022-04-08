import SwiftUI
import DesignKit

struct ArtistHeaderView: View {
    let thumbnail: URL
    let name: String
    let website: URL
    
    var body: some View {
        VStack(spacing: .vSpacing.interItem) {
            Avatar(url: thumbnail)
                .frame(width: 125, height: 125)
                .accessibilityLabel(
                    Text("Artist's profile picture", comment: "Describing artists avatar view")
                )
            
            Text(verbatim: name)
                .font(.title)
            
            Link(website: website)
                .foregroundColor(.accentColor)
        }
    }
}

extension ArtistHeaderView {
    init(artist: Artist) {
        self.init(
            thumbnail: artist.thumbnail,
            name: artist.name,
            website: artist.website
        )
    }
}

struct ArtistHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistHeaderView(artist: .kanye)
    }
}
