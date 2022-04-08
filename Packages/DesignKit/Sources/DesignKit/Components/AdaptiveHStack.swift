import SwiftUI

public struct AdaptiveStack<Content: View>: View {
    @Environment(\.sizeCategory)
    private var sizeCategory
    
    private let vAlignment: VerticalAlignment
        
    private let hAlignment: HorizontalAlignment
    
    private let vSpacing: CGFloat
    
    private let hSpacing: CGFloat
    
    private let content: Content
    
    public init(
        vAlignment: VerticalAlignment = .center,
        hAlignment: HorizontalAlignment = .center,
        vSpacing: CGFloat = .vSpacing.interItem,
        hSpacing: CGFloat = .hSpacing.interItem,
        @ViewBuilder content: () -> Content
    ) {
        self.vAlignment = vAlignment
        self.hAlignment = hAlignment
        self.vSpacing = vSpacing
        self.hSpacing = hSpacing
        self.content = content()
    }
    
    public var body: some View {
        if sizeCategory.isAccessibilityCategory {
            VStack(alignment: hAlignment, spacing: vSpacing, content: { content })
        } else {
            HStack(alignment: vAlignment, spacing: hSpacing, content: { content })
        }
    }
}

