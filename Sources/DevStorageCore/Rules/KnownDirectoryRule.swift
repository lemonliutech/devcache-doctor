import Foundation

public struct KnownDirectoryRule: ScanRule {
    public let id: String
    public let displayName: String
    public let toolchain: String
    public let category: StorageCategory
    public let riskLevel: RiskLevel
    public let defaultSelectedWhenFound: Bool
    public let explanation: String
    public let paths: [URL]

    public init(
        id: String,
        displayName: String,
        toolchain: String,
        category: StorageCategory,
        riskLevel: RiskLevel,
        defaultSelectedWhenFound: Bool,
        explanation: String,
        paths: [URL]
    ) {
        self.id = id
        self.displayName = displayName
        self.toolchain = toolchain
        self.category = category
        self.riskLevel = riskLevel
        self.defaultSelectedWhenFound = defaultSelectedWhenFound
        self.explanation = explanation
        self.paths = paths
    }

    public func scan(measurer: FileSizeMeasurer) -> [StorageItem] {
        paths.map { path in
            switch measurer.measure(url: path) {
            case .success(let size):
                return StorageItem(
                    id: "\(id):\(path.path)",
                    displayName: displayName,
                    path: path.path,
                    category: category,
                    toolchain: toolchain,
                    sizeBytes: size,
                    riskLevel: riskLevel,
                    status: .found,
                    defaultSelected: defaultSelectedWhenFound,
                    explanation: explanation,
                    exception: nil
                )
            case .failure(let exception):
                return StorageItem(
                    id: "\(id):\(path.path)",
                    displayName: displayName,
                    path: path.path,
                    category: category,
                    toolchain: toolchain,
                    sizeBytes: nil,
                    riskLevel: riskLevel,
                    status: exception.type == .pathNotFound ? .missing : .failed,
                    defaultSelected: false,
                    explanation: explanation,
                    exception: exception
                )
            }
        }
    }
}
