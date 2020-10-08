import XCTest
@testable import ThoughtParser

final class ThoughtParserTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ThoughtParser().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
