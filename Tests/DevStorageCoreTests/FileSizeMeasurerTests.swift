import Foundation
import XCTest
@testable import DevStorageCore

final class FileSizeMeasurerTests: XCTestCase {
    func testMeasuresNestedDirectorySize() throws {
        let root = try makeTemporaryDirectory()
        try Data(repeating: 1, count: 5).write(to: root.appendingPathComponent("a.bin"))
        let nested = root.appendingPathComponent("nested")
        try FileManager.default.createDirectory(at: nested, withIntermediateDirectories: true)
        try Data(repeating: 2, count: 7).write(to: nested.appendingPathComponent("b.bin"))

        let result = FileSizeMeasurer().measure(url: root)

        XCTAssertEqual(result, .success(12))
    }

    func testMissingPathReturnsPathNotFoundException() throws {
        let root = try makeTemporaryDirectory()
        let missing = root.appendingPathComponent("missing")

        let result = FileSizeMeasurer().measure(url: missing)

        guard case .failure(let exception) = result else {
            return XCTFail("Expected missing path failure")
        }
        XCTAssertEqual(exception.type, .pathNotFound)
        XCTAssertEqual(exception.operation, "measure")
    }

    private func makeTemporaryDirectory() throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("DevStorageCoreTests")
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
