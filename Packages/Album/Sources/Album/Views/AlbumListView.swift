import SwiftUI
import DesignKit

public struct AlbumListView<Details: View>: View {
    @EnvironmentObject
    private var model: AlbumsModel
    
    private var albums: [Album] {
        model.state.value
    }
    
    @ViewBuilder
    private let details: (Album) -> Details
    
    public init(@ViewBuilder details: @escaping (Album) -> Details) {
        self.details = details
    }
    
    public var body: some View {
        Group {
            if let error = model.error {
                ErrorView(error)
            } else {
                content
            }
        }
        .task { await model.loadData() }
        .refreshable { await model.loadData() }
    }
    
    @ViewBuilder
    private var content: some View {
        List {
            AlertView($model.alert)
                .hideListSeparator()
            
            ForEach(albums) { album in
                NavigationLink {
                    details(album)
                } label: {
                    AlbumListItemView(album: album)
                }
                .hideListSeparator()
            }
            .redacted(reason: model.redacted)
        }
    }
}

struct AAlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView { album in
            Text(verbatim: album.title)
        }
        .environmentObject(AlbumsModel.stubbed)
    }
}
