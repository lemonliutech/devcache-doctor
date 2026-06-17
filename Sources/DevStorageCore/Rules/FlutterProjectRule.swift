import Foundation

/// Scans a single explicitly configured Flutter project root,
/// returning one StorageItem per found artifact type.
public struct FlutterProjectRule: ScanRule {
    public let id: String
    public let displayName: String
    public let toolchain: String
    private let projectRoot: URL

    public init(projectRoot: URL) {
        self.id = "flutter-project:\(projectRoot.path)"
        self.displayName = "Flutter \(projectRoot.lastPathComponent)"
        self.toolchain = "Flutter / Dart / FVM"
        self.projectRoot = projectRoot
    }

    public func scan(measurer: FileSizeMeasurer) -> [StorageItem] {
        guard FileManager.default.fileExists(atPath: projectRoot.appendingPathComponent("pubspec.yaml").path) else {
            return []
        }

        let candidates: [(name: String, rel: String, category: StorageCategory, risk: RiskLevel)] = [
            ("build/",             "build",             .buildArtifact,   .medium),
            (".dart_tool/",        ".dart_tool",        .buildArtifact,   .medium),
            ("ios/Pods/",          "ios/Pods",          .dependencyStore, .medium),
            ("android/.gradle/",   "android/.gradle",   .buildArtifact,   .medium),
            ("android/app/build/", "android/app/build", .buildArtifact,   .medium),
            ("ohos/build/",        "ohos/build",        .buildArtifact,   .medium),
            ("build/app/outputs/", "build/app/outputs", .packageOutput,   .manualReview),
        ]

        return candidates.compactMap { name, rel, category, risk in
            let url = projectRoot.appendingPathComponent(rel)
            guard case .success(let size) = measurer.measure(url: url) else { return nil }
            return StorageItem(
                id: "flutter-project:\(url.path)",
                displayName: "\(projectRoot.lastPathComponent) / \(name)",
                path: url.path,
                category: category,
                toolchain: toolchain,
                sizeBytes: size,
                riskLevel: risk,
                status: .found,
                defaultSelected: false,
                explanation: projectRoot.lastPathComponent,
                exception: nil
            )
        }
    }
}
