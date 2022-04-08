import CoreGraphics

public struct Spacing {
    /// Spacing most commonly used within a component
    public let interItem: CGFloat
    
    /// Spacing most commonly used between components
    public let item: CGFloat
}

public extension CGFloat {
    static let vSpacing = Spacing(interItem: 2, item: 8)
    static let hSpacing = Spacing(interItem: 4, item: 16)
}
