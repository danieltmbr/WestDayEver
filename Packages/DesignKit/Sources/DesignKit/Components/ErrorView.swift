import SwiftUI

public struct ErrorView: View {
    
    @Environment(\.refresh)
    private var refresh
    
    private let error: String?
    
    public init(_ error: String?) {
        self.error = error
    }
    
    public var body: some View {
        if let error = error {
            content(error)
        }
    }
    
    @ViewBuilder
    private func content(_ error: String) -> some View {
        VStack(spacing: .vSpacing.item) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            
            Text(error)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            refreshButton
            Spacer()
        }
        .centered()
        .padding()
    }
    
    
    @ViewBuilder
    private var refreshButton: some View {
        if let refresh = refresh {
            Button {
                Task { await refresh() }
            } label: {
                HStack(spacing: .hSpacing.interItem) {
                    Image(systemName: "arrow.clockwise.circle")
                        .accessibilityHidden(true)
                    Text("Tap to reload", comment: "Reloading content that failed to load")
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView("Couldn't load data")
    }
}
