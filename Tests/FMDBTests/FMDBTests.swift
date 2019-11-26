import XCTest
@testable import FMDB

final class FMDBTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FMDB().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
