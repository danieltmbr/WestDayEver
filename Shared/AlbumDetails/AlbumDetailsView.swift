import SwiftUI
import Album
import Track
import DesignKit

struct AlbumDetailsView: View {
    private enum Constants {
        static let contentMaxWidth: CGFloat = 500
    }
    
    @EnvironmentObject
    private var model: TracksModel
    
    let album: Album
    
    private var tracks: [Track] {
        model.state.value
    }
    
    init(album: Album) {
        self.album = album
    }
    
    var body: some View {
        Group {
            if let error = model.error {
                ErrorView(error)
            } else {
                content
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .navigationTitle(album.title)
    }
    
    private var content: some View {
        List {
            header
            alert
            tracksList
            description
        }
        .listStyle(.plain)
        .task { await model.loadData() }
        .refreshable { await model.loadData() }
    }
    
    private var header: some View {
        AlbumHeaderView(album: album)
            .hideListSeparator()
            .centered(.horizontal)
    }
    
    private var alert: some View {
        AlertView($model.alert)
            .padding(.bottom, .vSpacing.item)
            .frame(maxWidth: Constants.contentMaxWidth)
            .centered(.horizontal)
            .hideListSeparator()
    }
    
    private var tracksList: some View {
        ForEach(tracks) { track in
            VStack {
                TrackListItemView(track: track)
                Divider()
            }
            .frame(maxWidth: Constants.contentMaxWidth)
            .centered(.horizontal)
            .hideListSeparator()
        }
        .redacted(reason: model.redacted)
    }
    
    @ViewBuilder
    private var description: some View {
        if !album.description.isEmpty {
            DetailItemView {
                Text("Description", comment: "Description label for album detail")
            } value: {
                Text(verbatim: album.description)
            }
            .padding(.top, .vSpacing.item)
            .frame(maxWidth: Constants.contentMaxWidth)
            .centered(.horizontal)
            .hideListSeparator()
        }
    }
}

struct AlbumDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailsView(album: Album.tlop)
            .environmentObject(TracksModel.stubbed)
    }
}
