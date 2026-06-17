import SwiftUI
import DevStorageCore

struct DiskPressureSummaryView: View {
    let results: [StorageItem]

    private var volumeAttrs: [FileAttributeKey: Any]? {
        try? FileManager.default.attributesOfFileSystem(
            forPath: FileManager.default.homeDirectoryForCurrentUser.path
        )
    }

    private var totalBytes: Int64 {
        Int64((volumeAttrs?[.systemSize] as? UInt64) ?? 0)
    }

    private var freeBytes: Int64 {
        Int64((volumeAttrs?[.systemFreeSize] as? UInt64) ?? 0)
    }

    private var usedBytes: Int64 { max(0, totalBytes - freeBytes) }

    private var lowRiskBytes: UInt64 {
        results.filter { $0.riskLevel == .low && $0.status == .found }
            .compactMap(\.sizeBytes).reduce(0, +)
    }

    private var mediumRiskBytes: UInt64 {
        results.filter { $0.riskLevel == .medium && $0.status == .found }
            .compactMap(\.sizeBytes).reduce(0, +)
    }

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: Spacing.base) {
                // Disk bar
                VStack(alignment: .leading, spacing: Spacing.tight) {
                    HStack {
                        Label("Macintosh HD", systemImage: "internaldrive")
                            .font(.headline)
                        Spacer()
                        Text(Int64(totalBytes).formatted(.byteCount(style: .file)))
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                    if totalBytes > 0 {
                        ProgressView(value: Double(usedBytes), total: Double(totalBytes))
                            .progressViewStyle(.linear)
                            .tint(.primary.opacity(0.4))
                    }

                    HStack {
                        Text(Int64(usedBytes).formatted(.byteCount(style: .file)) + " used")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(Int64(freeBytes).formatted(.byteCount(style: .file)) + " available")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Divider()

                // Recoverable summary
                HStack(spacing: Spacing.large) {
                    recoverableCell(
                        label: "Low Risk",
                        bytes: lowRiskBytes,
                        color: .riskLow,
                        icon: "checkmark.circle.fill"
                    )
                    recoverableCell(
                        label: "Medium Risk",
                        bytes: mediumRiskBytes,
                        color: .riskMedium,
                        icon: "exclamationmark.circle.fill"
                    )
                    Spacer()
                }
            }
        }
    }

    private func recoverableCell(label: String, bytes: UInt64, color: Color, icon: String) -> some View {
        HStack(spacing: Spacing.tight) {
            Image(systemName: icon)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 1) {
                Text(UInt64(bytes).formatted(.byteCount(style: .file)))
                    .font(.callout)
                    .fontWeight(.medium)
                    .monospacedDigit()
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
