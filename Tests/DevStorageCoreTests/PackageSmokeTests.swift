import XCTest
@testable import DevStorageCore

final class PackageSmokeTests: XCTestCase {
    func testLibraryExposesVersionString() {
        XCTAssertEqual(DevStorageCore.version, "0.2.0-scanner")
    }
}
