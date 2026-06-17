import XCTest
@testable import DevStorageCore

final class DevelopmentStorageScannerTests: XCTestCase {
    func testScannerAggregatesRules() throws {
        let first = try makeTemporaryDirectory(named: "first")
        let second = try makeTemporaryDirectory(named: "second")
        try Data(repeating: 1, count: 4).write(to: first.appendingPathComponent("a.bin"))
        try Data(repeating: 2, count: 6).write(to: second.appendingPathComponent("b.bin"))

        let rules: [any ScanRule] = [
            KnownDirectoryRule(
                id: "first-rule",
                displayName: "First",
                toolchain: "Test",
                category: .cache,
                riskLevel: .low,
                defaultSelectedWhenFound: true,
                explanation: "First test rule.",
                paths: [first]
            ),
            KnownDirectoryRule(
                id: "second-rule",
                displayName: "Second",
                toolchain: "Test",
                category: .buildArtifact,
                riskLevel: .medium,
                defaultSelectedWhenFound: false,
                explanation: "Second test rule.",
                paths: [second]
            )
        ]

        let results = DevelopmentStorageScanner(rules: rules).scan()

        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results.map(\.sizeBytes).compactMap { $0 }.reduce(0, +), 10)
    }

    private func makeTemporaryDirectory(named name: String) throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("DevelopmentStorageScannerTests")
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent(name)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
