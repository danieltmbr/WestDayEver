import SwiftUI
import DesignKit

public struct AlbumHeaderView: View {
    private let artwork: URL
    private let info: String
    
    public var body: some View {
        VStack(spacing: .vSpacing.interItem) {
            Artwork(url: artwork)
                .frame(width: 200, height: 200)
                .padding(.vSpacing.interItem)
                .accessibilityLabel(
                    Text("Album's artwork image", comment: "Describing album's cover picture")
                )
            
            Text(verbatim: info)
        }
        .accessibilityElement(children: .combine)
    }
}

public extension AlbumHeaderView {
    init(album: Album) {
        let info: String
        switch (album.genre.isEmpty, album.released == 0) {
        case (true, true): info = ""
        case (true, false): info = "\(album.released)"
        case (false, true): info = "\(album.genre)"
        case (false, false): info = "\(album.genre) • \(album.released)"
        }
        self.init(
            artwork: album.artwork,
            info: info
        )
    }
}

struct AlbumHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumHeaderView(album: .tlop)
    }
}
