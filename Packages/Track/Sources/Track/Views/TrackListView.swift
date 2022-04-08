import SwiftUI
import DesignKit

public struct TrackListView: View {
    @EnvironmentObject
    private var model: TracksModel
    
    private var tracks: [Track] {
        model.state.value
    }

    public init() {}
    
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
        VStack {
            AlertView($model.alert)

            ForEach(tracks) { track in
                TrackListItemView(track: track)
            }
            .redacted(reason: model.redacted)
        }
    }
}

struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView()
            .environmentObject(TracksModel.stubbed)
    }
}
