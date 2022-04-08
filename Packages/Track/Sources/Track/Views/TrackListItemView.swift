import SwiftUI
import DesignKit

public struct TrackListItemView: View {
    let trackNumber: Int
    let title: String
    let duration: String
    
    public var body: some View {
        AdaptiveStack(hAlignment: .leading) {            
            Text(verbatim: "\(trackNumber)")
                .foregroundColor(.secondary)
            
            HStack {
                Text(verbatim: title)
                Spacer()
            }
            
            Text(verbatim: duration)
                .foregroundColor(.secondary)
                .accessibilityLabel(
                    Text(
                        "Length: \(duration)",
                        comment: "Accessibility label describing the duration of a track"
                    )
                )
        }
        .accessibilityElement(children: .combine)
    }
}

extension TrackListItemView {
    public init(track: Track, durationFormatter: DateComponentsFormatter = .durationFormatter) {
        trackNumber = track.trackNumber
        title = track.title
        duration = durationFormatter.string(from: track.duration) ?? "\(track.duration)s"
    }
}

public extension DateComponentsFormatter {
    static var durationFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        return formatter
    }
}

struct TrackListItemView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListItemView(track: .saintPablo)
    }
}
