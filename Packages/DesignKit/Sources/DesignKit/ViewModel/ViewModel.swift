import Foundation
import SwiftUI

public final class ViewModel<Value: Equatable>: ObservableObject {
    
    @Published
    public private(set) var state: State<Value>

    public var redacted: RedactionReasons {
        state.kind == .placeholder ? .placeholder : []
    }
    
    @Published
    public var alert: String?
    
    @Published
    public private(set) var error: String?
    
    private let fetcher: () -> AsyncThrowingStream<Value, Error>
    
    public init(
        placeholder: Value,
        fetcher: @escaping () -> AsyncThrowingStream<Value, Error>
    ) {
        state = .placeholder(placeholder)
        self.fetcher = fetcher
    }
    
    public convenience init<S: AsyncSequence>(
        placeholder: Value,
        sequence: @escaping () -> S
    ) where S.Element == Value {
        self.init(
            placeholder: placeholder,
            fetcher: {
                var iterator = sequence().makeAsyncIterator()
                return AsyncThrowingStream<Value, Error> {
                    try await iterator.next()
                }
            }
        )
    }
    
    @MainActor
    public func loadData() async {
        do {
            error = nil
            alert = nil
            for try await value in fetcher() where state.value != value {
                state = .value(value)
            }
        } catch {
            // TODO: Log error
            switch state.kind {
            case .placeholder:
                self.error = "Couldn't load content. Try again later."
            case .concrete:
                alert = "The content might be outdated as refreshing wasn't successful."
            }
        }
    }
}
