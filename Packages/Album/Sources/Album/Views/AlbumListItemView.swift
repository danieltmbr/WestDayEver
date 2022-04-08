import SwiftUI
import DesignKit

struct AlbumListItemView: View {
    let artwork: URL
    let title: String
    let info: String
    
    var body: some View {
        AdaptiveStack(
            vAlignment: .center,
            hAlignment: .leading,
            vSpacing: .vSpacing.interItem * 2,
            hSpacing: .hSpacing.interItem * 2
        ) {
            Artwork(url: artwork)
                .frame(width: 60, height: 60)
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: .vSpacing.interItem) {
                Text(verbatim: title)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text(verbatim: info)
                    .font(.callout)
                    .accessibilityHidden(info.isEmpty)
            }
            .accessibilityElement(children: .combine)
        }
    }
}

extension AlbumListItemView {

    init(album: Album) {
        let info: String
        switch (album.genre.isEmpty, album.released == 0) {
        case (true, true): info = ""
        case (true, false): info = "\(album.released)"
        case (false, true): info = "\(album.genre)"
        case (false, false): info = "\(album.released), \(album.genre)"
        }
        
        artwork = album.artwork
        title = album.title
        self.info = info
    }
}

struct AlbumListItemView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListItemView(album: .tlop)
    }
}
