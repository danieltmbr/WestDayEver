import Foundation

public protocol Storage {
    associatedtype Key
    associatedtype Value
    
    func save(_ value: Value, with key: Key) async throws
    
    func load(with key: Key) async throws -> Value?
    
    func clear(with key: Key) async throws
}
