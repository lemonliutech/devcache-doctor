import SwiftUI
import DevStorageCore

struct StorageItemRowView: View {
    let item: StorageItem
    let isSelected: Bool
    let onToggle: () -> Void

    @State private var isExpanded = false
    @State private var isHovered  = false

    private var canSelect: Bool {
        item.status == .found
        && item.riskLevel != .protected
        && item.riskLevel != .unsupported
        && item.category != .packageOutput
    }

    var body: some View {
        VStack(spacing: 0) {
            // Collapsed row
            HStack(spacing: Spacing.base) {
                selectionControl
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.displayName)
                        .font(.bodySmall)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.textPrimary)
                    Text(item.explanation)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text(item.toolchain)
                    .font(.caption)
                    .foregroundStyle(Color.textMuted)
                    .frame(width: 130, alignment: .trailing)
                    .lineLimit(1)

                sizeLabel
                    .frame(width: 72, alignment: .trailing)

                RiskBadgeView(riskLevel: item.riskLevel)
                    .frame(width: 104, alignment: .trailing)

                Image(systemName: isExpanded ? "chevron.up" : "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.textMuted)
                    .rotationEffect(isExpanded ? .degrees(0) : .degrees(0))
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.small)
            .contentShape(Rectangle())
            .onHover { isHovered = $0 }
            .onTapGesture {
                withAnimation(.standard) {
                    isExpanded.toggle()
                }
            }

            // Expanded detail
            if isExpanded {
                expandedDetail
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(isHovered ? Color.bgElevated : Color.clear)
        .animation(.micro, value: isHovered)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var selectionControl: some View {
        if item.riskLevel == .protected {
            Image(systemName: "lock.fill")
                .font(.caption)
                .foregroundStyle(Color.riskProtected)
        } else if !canSelect {
            Image(systemName: "minus")
                .font(.caption)
                .foregroundStyle(Color.textMuted)
        } else {
            Button(action: onToggle) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isSelected ? Color.accentPrimary : Color.textMuted)
                    .font(.system(size: 14))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(item.displayName), \(isSelected ? "selected" : "not selected")")
        }
    }

    @ViewBuilder
    private var sizeLabel: some View {
        if let bytes = item.sizeBytes {
            Text(formatBytes(bytes))
                .font(.bodySmall)
                .fontWeight(.medium)
                .foregroundStyle(Color.textPrimary)
                .monospacedDigit()
        } else {
            Text("—")
                .font(.bodySmall)
                .foregroundStyle(Color.textMuted)
        }
    }

    private var expandedDetail: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Divider()
                .background(Color.borderSubtle)
                .padding(.horizontal, Spacing.medium)

            VStack(spacing: Spacing.tight) {
                detailRow(label: "Path", value: item.path, isPath: true)
                detailRow(label: "Risk", value: item.riskLevel.rawValue.capitalized)
                detailRow(label: "Category", value: item.category.rawValue.capitalized)
                if let ex = item.exception {
                    detailRow(label: "Issue", value: ex.message)
                    detailRow(label: "Suggestion", value: ex.suggestion)
                }
            }
            .padding(.horizontal, Spacing.medium + 20 + Spacing.base)
            .padding(.bottom, Spacing.base)
        }
    }

    private func detailRow(label: String, value: String, isPath: Bool = false) -> some View {
        HStack(alignment: .top, spacing: Spacing.small) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.textMuted)
                .frame(width: 72, alignment: .trailing)

            if isPath {
                Text(value)
                    .font(.mono)
                    .foregroundStyle(Color.textSecondary)
                    .textSelection(.enabled)
                    .lineLimit(2)
            } else {
                Text(value)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .textSelection(.enabled)
            }

            Spacer()
        }
    }

    private func formatBytes(_ bytes: UInt64) -> String {
        let gb = Double(bytes) / 1_073_741_824
        if gb >= 1 { return String(format: "%.1f GB", gb) }
        let mb = Double(bytes) / 1_048_576
        if mb >= 1 { return String(format: "%.0f MB", mb) }
        let kb = Double(bytes) / 1024
        if kb >= 1 { return String(format: "%.0f KB", kb) }
        return "\(bytes) B"
    }
}
