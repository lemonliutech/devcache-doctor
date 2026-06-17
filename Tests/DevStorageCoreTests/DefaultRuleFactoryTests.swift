import XCTest
@testable import DevStorageCore

final class DefaultRuleFactoryTests: XCTestCase {
    func testDefaultRulesIncludeMobileCrossPlatformToolchains() {
        let home = URL(fileURLWithPath: "/Users/tester", isDirectory: true)
        let rules = DefaultRuleFactory.defaultRules(homeDirectory: home, projectRoots: [])
        let ids = Set(rules.map(\.id))

        XCTAssertTrue(ids.contains("xcode-derived-data"))
        XCTAssertTrue(ids.contains("xcode-new-derived-data"))
        XCTAssertTrue(ids.contains("gradle-caches"))
        XCTAssertTrue(ids.contains("dart-pub-hosted"))
        XCTAssertTrue(ids.contains("dart-pub-git"))
        XCTAssertTrue(ids.contains("fvm-versions"))
        XCTAssertTrue(ids.contains("pnpm-store"))
        XCTAssertTrue(ids.contains("npm-cache"))
        XCTAssertTrue(ids.contains("cocoapods-cache"))
        XCTAssertTrue(ids.contains("ohpm-cache"))
        XCTAssertTrue(ids.contains("hvigor-cache"))
    }
}
