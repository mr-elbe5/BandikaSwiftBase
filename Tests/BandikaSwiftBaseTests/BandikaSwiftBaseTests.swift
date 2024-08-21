import XCTest
@testable import BandikaSwiftBase

final class BandikaSwiftBaseTests: XCTestCase {
    func testPaths() {
        XCTAssertTrue(Files.fileExists(path: Paths.baseDirectory))
    }

    static var allTests = [
        ("testPaths", testPaths),
    ]
}
