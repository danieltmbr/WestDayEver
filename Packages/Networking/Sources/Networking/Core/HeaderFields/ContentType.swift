import Foundation

public enum ContentType: String, HttpHeaderField {
    case json = "application/json;charset=UTF-8"

    private static let headerKey = "Content-Type"
    public var key: String { Self.headerKey }
    public var value: String { rawValue }
}
