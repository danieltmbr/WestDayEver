import Foundation

public protocol HttpHeaderField {
    var key: String { get }
    var value: String { get }
}

public struct CustomHttpHeaderField: HttpHeaderField {
    public let key: String
    public let value: String
}
