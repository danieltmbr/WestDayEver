import SwiftUI

public struct Avatar: View {
    @Environment(\.redactionReasons)
    private var redactionReasons
    
    private let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(url: redactionReasons.isEmpty ? url : nil) { phase in
            if let image = phase.image  {
                image.resizable()
            } else if phase.error != nil {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.secondary)
            } else {
                ProgressView()
            }
        }
        .mask(Circle())
        .overlay {
            if !redactionReasons.isEmpty {
                Circle().fill(.secondary)
            }
        }
    }
}

struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        Avatar(url: URL(string: "https://www.theaudiodb.com/images/media/artist/thumb/wttxqu1435514924.jpg"))
    }
}
