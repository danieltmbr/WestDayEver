import XCTest

import NetworkingTests

var tests = [XCTestCaseEntry]()
tests += HttpMethodTests.allTests()
XCTMain(tests)
