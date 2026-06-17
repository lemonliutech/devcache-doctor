import Foundation

/// Scans common developer directories for Flutter projects (pubspec.yaml),
/// then measures build artifacts and package outputs inside each found project.
public struct FlutterProjectDiscoveryRule: ScanRule {
    public let id = "flutter-project-discovery"
    public let displayName = "Flutter projects (scanning home directory…)"
    public let toolchain = "Flutter / Dart / FVM"

    private let searchRoots: [URL]

    // Directories to skip while walking — avoids artifact dirs and system paths
    private static let skipDirs: Set<String> = [
        // Build artifacts (would contain nested pubspec.yaml in Flutter)
        "build", ".dart_tool", ".pub-cache", ".gradle", "DerivedData", "Pods",
        // VCS / tooling noise
        ".git", "node_modules",
        // macOS system — no Flutter projects here
        "Library", "Applications", "System", ".Trash",
        // Common VM / container paths
        ".lima", ".docker", ".colima",
    ]

    // Max depth from home — deep enough to find nested monorepos
    private static let maxDepth = 8

    public init(homeDirectory: URL) {
        // Scan entire home directory
        searchRoots = [homeDirectory]
    }

    public func scan(measurer: FileSizeMeasurer) -> [StorageItem] {
        let fm = FileManager.default
        var projectRoots: [URL] = []

        for root in searchRoots {
            var isDir: ObjCBool = false
            guard fm.fileExists(atPath: root.path, isDirectory: &isDir), isDir.boolValue else { continue }
            discoverFlutterProjects(in: root, depth: 0, fm: fm, result: &projectRoots)
        }

        guard !projectRoots.isEmpty else { return [] }

        return projectRoots.flatMap { root in
            FlutterProjectRule(projectRoot: root).scan(measurer: measurer)
        }
    }

    private func discoverFlutterProjects(
        in directory: URL,
        depth: Int,
        fm: FileManager,
        result: inout [URL]
    ) {
        guard depth < Self.maxDepth else { return }

        let pubspec = directory.appendingPathComponent("pubspec.yaml")
        if fm.fileExists(atPath: pubspec.path) {
            result.append(directory)
            // Don't descend further once a project root is found
            return
        }

        guard let entries = try? fm.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else { return }

        for entry in entries {
            let name = entry.lastPathComponent
            guard !Self.skipDirs.contains(name) else { continue }

            var isDir: ObjCBool = false
            guard fm.fileExists(atPath: entry.path, isDirectory: &isDir), isDir.boolValue else { continue }

            discoverFlutterProjects(in: entry, depth: depth + 1, fm: fm, result: &result)
        }
    }
}
