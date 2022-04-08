import SwiftUI
import Artist
import Album
import Track

struct ContentView: View {
    @State
    private var presentArtist: Bool = false
    
    var body: some View {
        NavigationView {
            AlbumListView { album in
                AlbumDetailsView(album: album)
                    .environmentObject(TracksModel.default(for: album.id))
            }
            .listStyle(.sidebar)
            .navigationTitle(
                Text("Albums", comment: "Title of the main screen")
            )
            .toolbar {
                ToolbarItem(id: "Artist", placement: .navigation, showsByDefault: true) {
                    artistButton
                }
            }
#if os(macOS)
            .frame(minWidth: 240)
#endif
            
            Text("Select and album", comment: "Placeholder content for when the detail view is empty")
        }
        .sheet(isPresented: $presentArtist) {
            ArtistView()
                .frame(idealWidth: 500, idealHeight: 400)
        }
    }
    
    private var artistButton: some View {
        Button {
            presentArtist.toggle()
        } label: {
            Image(systemName: "person.crop.circle")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
