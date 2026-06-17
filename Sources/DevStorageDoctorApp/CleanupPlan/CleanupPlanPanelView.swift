import SwiftUI
import DevStorageCore

struct CleanupPlanPanelView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            Divider().background(Color.borderSubtle)

            if state.selectedItems.isEmpty {
                emptyState
            } else {
                planContent
            }
        }
        .frame(width: 220)
        .background(Color.bgSurface)
    }

    // MARK: - Header

    private var header: some View {
        Text("Cleanup Plan")
            .font(.headingSmall)
            .foregroundStyle(Color.textPrimary)
            .padding(Spacing.medium)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: Spacing.base) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 32))
                .foregroundStyle(Color.textMuted)
            Text("Select items to\nbuild a plan")
                .font(.bodySmall)
                .foregroundStyle(Color.textMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: - Plan Content

    private var planContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    recoveryFigure
                    riskBreakdown
                    protectedNote
                }
                .padding(Spacing.medium)
            }

            Divider().background(Color.borderSubtle)

            generateButton
                .padding(Spacing.medium)
        }
    }

    private var recoveryFigure: some View {
        VStack(alignment: .leading, spacing: Spacing.tight) {
            Text("Estimated recovery")
                .font(.caption)
                .foregroundStyle(Color.textMuted)
            Text(formatBytes(state.estimatedRecoveryBytes))
                .font(.displayMedium)
                .foregroundStyle(Color.accentPrimary)
                .monospacedDigit()
            Text("\(state.selectedItems.count) items selected")
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
        }
    }

    private var riskBreakdown: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Risk breakdown")
                .font(.caption)
                .foregroundStyle(Color.textMuted)

            let low    = state.selectedItems.filter { $0.riskLevel == .low }.count
            let medium = state.selectedItems.filter { $0.riskLevel == .medium }.count
            let high   = state.selectedItems.filter { $0.riskLevel == .high }.count

            if low > 0    { riskLine(color: .riskLow,    label: "Low",    count: low) }
            if medium > 0 { riskLine(color: .riskMedium, label: "Medium", count: medium) }
            if high > 0   { riskLine(color: .riskHigh,   label: "High",   count: high) }
        }
    }

    private func riskLine(color: Color, label: String, count: Int) -> some View {
        HStack(spacing: Spacing.small) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
            Spacer()
            Text("\(count)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(Color.textPrimary)
                .monospacedDigit()
        }
    }

    private var protectedNote: some View {
        let protected = state.results.filter {
            $0.riskLevel == .protected || $0.category == .packageOutput
        }.count

        return Group {
            if protected > 0 {
                HStack(spacing: Spacing.tight) {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(Color.riskProtected)
                    Text("\(protected) item\(protected == 1 ? "" : "s") excluded")
                        .font(.caption)
                        .foregroundStyle(Color.textMuted)
                }
            }
        }
    }

    private var generateButton: some View {
        Button {
            // TODO: navigate to cleanup plan screen
        } label: {
            Text("Generate Plan")
                .font(.bodySmall)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.small)
                .background(Color.accentPrimary)
                .foregroundStyle(Color.bgBase)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .disabled(state.selectedItems.isEmpty)
        .accessibilityLabel("Generate cleanup plan")
    }

    private func formatBytes(_ bytes: UInt64) -> String {
        let gb = Double(bytes) / 1_073_741_824
        if gb >= 1 { return String(format: "%.1f GB", gb) }
        let mb = Double(bytes) / 1_048_576
        if mb >= 1 { return String(format: "%.0f MB", mb) }
        return "\(bytes) B"
    }
}
