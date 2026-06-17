import SwiftUI
import DevStorageCore

struct DiskPressureSummaryView: View {
    let results: [StorageItem]

    private var totalBytes: UInt64 {
        (try? FileManager.default.attributesOfFileSystem(
            forPath: FileManager.default.homeDirectoryForCurrentUser.path
        )[.systemSize] as? UInt64) ?? 0
    }

    private var freeBytes: UInt64 {
        (try? FileManager.default.attributesOfFileSystem(
            forPath: FileManager.default.homeDirectoryForCurrentUser.path
        )[.systemFreeSize] as? UInt64) ?? 0
    }

    private var usedBytes: UInt64 {
        totalBytes > freeBytes ? totalBytes - freeBytes : 0
    }

    private var lowRiskBytes: UInt64 {
        results.filter { $0.riskLevel == .low && $0.status == .found }
            .compactMap(\.sizeBytes).reduce(0, +)
    }

    private var mediumRiskBytes: UInt64 {
        results.filter { $0.riskLevel == .medium && $0.status == .found }
            .compactMap(\.sizeBytes).reduce(0, +)
    }

    private var manualReviewBytes: UInt64 {
        results.filter { $0.category == .packageOutput && $0.status == .found }
            .compactMap(\.sizeBytes).reduce(0, +)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.base) {
            HStack {
                Text("Macintosh HD")
                    .font(.headingSmall)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text(formatBytes(totalBytes))
                    .font(.bodySmall)
                    .foregroundStyle(Color.textSecondary)
            }

            diskBar

            HStack(spacing: Spacing.large) {
                diskStatCell(
                    label: "Used",
                    bytes: usedBytes,
                    color: Color.bgOverlay
                )
                diskStatCell(
                    label: "Available",
                    bytes: freeBytes,
                    color: Color.textSecondary
                )
                Spacer()
                recoverableCell(label: "Low Risk", bytes: lowRiskBytes, color: .riskLow)
                recoverableCell(label: "Medium Risk", bytes: mediumRiskBytes, color: .riskMedium)
                recoverableCell(label: "Manual Review", bytes: manualReviewBytes, color: .riskManual)
            }
        }
        .padding(Spacing.xl)
        .background(Color.bgSurface)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var diskBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.bgOverlay)
                    .frame(height: 8)

                if totalBytes > 0 {
                    let usedFraction = CGFloat(usedBytes) / CGFloat(totalBytes)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.borderStrong)
                        .frame(width: proxy.size.width * usedFraction, height: 8)
                }
            }
        }
        .frame(height: 8)
    }

    private func diskStatCell(label: String, bytes: UInt64, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.textMuted)
            Text(formatBytes(bytes))
                .font(.bodySmall)
                .fontWeight(.medium)
                .foregroundStyle(color)
                .monospacedDigit()
        }
    }

    private func recoverableCell(label: String, bytes: UInt64, color: Color) -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.textMuted)
            Text(formatBytes(bytes))
                .font(.bodySmall)
                .fontWeight(.medium)
                .foregroundStyle(color)
                .monospacedDigit()
        }
    }

    private func formatBytes(_ bytes: UInt64) -> String {
        let gb = Double(bytes) / 1_073_741_824
        if gb >= 1 { return String(format: "%.1f GB", gb) }
        let mb = Double(bytes) / 1_048_576
        if mb >= 1 { return String(format: "%.0f MB", mb) }
        return "\(bytes) B"
    }
}
