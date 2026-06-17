public protocol ScanRule: Sendable {
    var id: String { get }
    var displayName: String { get }
    var toolchain: String { get }
    func scan(measurer: FileSizeMeasurer) -> [StorageItem]
}
