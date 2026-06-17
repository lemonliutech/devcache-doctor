public struct DevelopmentStorageScanner {
    private let rules: [any ScanRule]
    private let measurer: FileSizeMeasurer

    public init(rules: [any ScanRule], measurer: FileSizeMeasurer = FileSizeMeasurer()) {
        self.rules = rules
        self.measurer = measurer
    }

    public func scan() -> [StorageItem] {
        rules.flatMap { rule in
            rule.scan(measurer: measurer)
        }
    }
}
