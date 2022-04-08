import SwiftUI

extension View {
    public func hideListSeparator() -> some View {
        #if os(iOS)
            return self
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
        #else
            return self
        #endif
    }
}
