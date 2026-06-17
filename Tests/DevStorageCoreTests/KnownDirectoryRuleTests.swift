import XCTest
@testable import DevStorageCore

final class KnownDirectoryRuleTests: XCTestCase {
    func testFoundDirectoryProducesStorageItem() throws {
        let root = try makeTemporaryDirectory()
        try Data(repeating: 3, count: 9).write(to: root.appendingPathComponent("cache.bin"))

        let rule = KnownDirectoryRule(
            id: "xcode-derived-data",
            displayName: "Xcode DerivedData",
            toolchain: "Xcode / iOS",
            category: .cache,
            riskLevel: .low,
            defaultSelectedWhenFound: true,
            explanation: "Can be rebuilt automatically. The next build may be slower.",
            paths: [root]
        )

        let results = rule.scan(measurer: FileSizeMeasurer())

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].status, .found)
        XCTAssertEqual(results[0].sizeBytes, 9)
        XCTAssertEqual(results[0].defaultSelected, true)
        XCTAssertEqual(results[0].riskLevel, .low)
    }

    func testMissingDirectoryProducesStructuredMissingItem() throws {
        let root = try makeTemporaryDirectory()
        let missing = root.appendingPathComponent("missing-cache")

        let rule = KnownDirectoryRule(
            id: "pub-cache",
            displayName: "Dart pub cache",
            toolchain: "Flutter / Dart / FVM",
            category: .dependencyStore,
            riskLevel: .medium,
            defaultSelectedWhenFound: false,
            explanation: "Dependencies may need to be downloaded again.",
            paths: [missing]
        )

        let results = rule.scan(measurer: FileSizeMeasurer())

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].status, .missing)
        XCTAssertEqual(results[0].exception?.type, .pathNotFound)
        XCTAssertEqual(results[0].defaultSelected, false)
    }

    private func makeTemporaryDirectory() throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("KnownDirectoryRuleTests")
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
