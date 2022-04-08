import Foundation

@dynamicMemberLookup
public struct State<Value>: Equatable
where Value: Equatable {
    enum Kind: Equatable {
        /// Placeholder is used to render redacted loading content
        case placeholder
        /// Concrete is Used to display valid data
        case concrete
    }
    
    let kind: Kind
    
    public let value: Value
    
    static func value(_ value: Value) -> Self {
        self.init(kind: .concrete, value: value)
    }
    
    static func placeholder(_ placeholder: Value) -> Self {
        self.init(kind: .placeholder, value: placeholder)
    }
    
    private init(kind: Kind, value: Value) {
        self.kind = kind
        self.value = value
    }
    
    public subscript<V>(dynamicMember keyPath: KeyPath<Value, V>) -> V {
        value[keyPath: keyPath]
    }
}
