import SwiftUI

public struct Artwork: View {
    private let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image  {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if phase.error != nil {
                Image(systemName: "music.mic.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .foregroundColor(.secondary)
                    .background(.tertiary)
            } else {
                ProgressView()
            }
        }
        .mask(RoundedRectangle(cornerRadius: 10))
        .shadow(
            color: .black.opacity(0.1),
            radius: 4, x: 1, y: 2
        )
    }
}

struct Artwork_Previews: PreviewProvider {
    static var previews: some View {
        Artwork(url: URL(string: "https://upload.wikimedia.org/wikipedia/en/4/4d/The_life_of_pablo_alternate.jpg")!)
            .frame(width: 120, height: 120)
    }
}
