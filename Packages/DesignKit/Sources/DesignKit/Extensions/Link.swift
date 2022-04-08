import SwiftUI

public extension Link where Label == HStack<TupleView<(Text, ModifiedContent<Image, AccessibilityAttachmentModifier>)>> {
    init(website: URL) {
        self.init(destination: website) {
            HStack(alignment: .center, spacing: .hSpacing.interItem) {
                Text(verbatim: website.absoluteString)
                Image(systemName: "arrow.up.forward.app")
                    .accessibilityHidden(true)
            }
        }
    }
}
