import XCTest
@testable import Networking

final class HttpMethodTests: XCTestCase {

    static var allTests = [
        ("test_rawValues", test_rawValues),
    ]

    /// Pouring concrete on raw values as those are not subjects of any future changes
    func test_rawValues() {
        XCTAssertEqual(HttpMethod.get.rawValue, "GET")
        XCTAssertEqual(HttpMethod.post.rawValue, "POST")
    }
}
