import SwiftUI
import Artist
import Album

@main
struct WestDayEverApp: App {
    
    @StateObject
    private var artistModel = ArtistModel.kanye
    
    @StateObject
    private var albumsModel = AlbumsModel.kanye
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(artistModel)
                .environmentObject(albumsModel)
        }
        .commands {
            SidebarCommands()
        }
    }
}
