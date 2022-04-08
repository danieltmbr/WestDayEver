import SwiftUI
import DesignKit

public struct ArtistView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @EnvironmentObject
    private var model: ArtistModel
    
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
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Done", comment: "Closing the artist popup window")
                }
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ArtistHeaderView(artist: model.state.value)
                    .frame(maxWidth: .infinity)
                
                AlertView($model.alert)
                
                ArtistDetailsView(artist: model.state.value)
            }
            .padding()
            .hideListSeparator()
        }
        .redacted(reason: model.redacted)
    }
}

struct ArtistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView()
            .environmentObject(ArtistModel.stubbed)
    }
}
