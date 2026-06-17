import Foundation

public struct FileSizeMeasurer {
    private let fileManager: FileManager

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    public func measure(url: URL) -> Result<UInt64, ScanException> {
        guard fileManager.fileExists(atPath: url.path) else {
            return .failure(
                ScanException(
                    type: .pathNotFound,
                    operation: "measure",
                    message: "Path does not exist: \(url.path)",
                    suggestion: "No action is required if this toolchain is not installed."
                )
            )
        }

        do {
            let size = try recursiveSize(url: url)
            return .success(size)
        } catch {
            return .failure(
                ScanException(
                    type: .permissionDenied,
                    operation: "measure",
                    message: "Could not read path: \(url.path). \(error.localizedDescription)",
                    suggestion: "Grant Full Disk Access, close the owning app, or exclude this path."
                )
            )
        }
    }

    private func recursiveSize(url: URL) throws -> UInt64 {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return 0
        }

        if !isDirectory.boolValue {
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            let size = attributes[.size] as? NSNumber
            return size?.uint64Value ?? 0
        }

        guard let enumerator = fileManager.enumerator(
            at: url,
            includingPropertiesForKeys: [.isRegularFileKey, .fileSizeKey],
            options: [.skipsHiddenFiles],
            errorHandler: { _, _ in false }
        ) else {
            return 0
        }

        var total: UInt64 = 0
        for case let fileURL as URL in enumerator {
            let values = try fileURL.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey])
            if values.isRegularFile == true {
                total += UInt64(values.fileSize ?? 0)
            }
        }
        return total
    }
}
