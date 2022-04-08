import SwiftUI

public struct AlertView: View {
    
    @Environment(\.refresh)
    private var refresh
    
    @Binding
    private var alert: String?
    
    public init(_ alert: Binding<String?>) {
        self._alert = alert
    }
    
    public var body: some View {
        if let alert = alert {
            content(alert)
                .foregroundColor(.orange)
                .padding(8)
                .background(.orange.opacity(0.1))
                .mask(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private func content(_ alert: String) -> some View {
#if os(iOS)
        HStack(alignment: .top, spacing: .hSpacing.item) {
            label(alert)
            Spacer()
            dismissButton
        }
#else
        VStack(alignment: .leading, spacing: .vSpacing.item) {
            label(alert)
            refreshButton
                .centered(.horizontal)
        }
#endif
    }
    
    private func label(_ alert: String) -> some View {
        HStack(alignment: .top, spacing: .hSpacing.interItem) {
            Image(systemName: "info.circle")
                .font(.body.bold())
                .accessibilityHidden(true)
            Text(alert)
                .lineLimit(nil)
        }
    }
    
    #if os(iOS)
    private var dismissButton: some View {
        Button {
            alert = nil
        } label: {
            Image(systemName: "xmark.circle.fill")
                .accessibilityLabel(Text("Dismiss alert", comment: "Dismiss button on alert views"))
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
    }    
    #endif
    
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
            .foregroundColor(.accentColor)
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(.constant("Couldn't fetch artist"))
    }
}
