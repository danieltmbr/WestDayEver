import SwiftUI

public struct Centering: OptionSet {
    public static let horizontal = Centering(rawValue: 1)
    public static let vertical = Centering(rawValue: 1 << 1)
    
    public static let all: Centering = [.horizontal, .vertical]
    
    public let rawValue: Int8
    
    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }
}

struct CenteredViewModifier: ViewModifier {
    let centering: Centering
    
    func body(content: Content) -> some View {
        content
            .centerVertically(centering.contains(.vertical))
            .centerHorizontally(centering.contains(.horizontal))
    }
}

extension View {
    public func centered(_ centering: Centering = .all) -> some View {
        modifier(CenteredViewModifier(centering: centering))
    }
    
    @ViewBuilder
    fileprivate func centerVertically(_ center: Bool) -> some View {
        if center {
            VStack {
                Spacer()
                self
                Spacer()
            }
        } else {
            self
        }
    }
    
    @ViewBuilder
    fileprivate func centerHorizontally(_ center: Bool) -> some View {
        if center {
            HStack {
                Spacer()
                self
                Spacer()
            }
        } else {
            self
        }
    }
}
