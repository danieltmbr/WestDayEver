import Foundation

public protocol Fetcher {
    associatedtype Parameters
    associatedtype Stream: AsyncSequence
    
    typealias Model = Stream.Element
    
//    typealias Stream = AsyncSequence where Stream.Element == Model
    
//    typealias Stream = AsyncThrowingStream<Model, Error>
    
    func fetch(with params: Parameters) -> Stream
}
