import SwiftUI
import DevStorageCore

struct CleanupPlanPanelView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if state.selectedItems.isEmpty {
                emptyState
            } else {
                planContent
            }
        }
        .frame(minWidth: 200, idealWidth: 220)
    }

    // MARK: - Empty

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Items Selected", systemImage: "tray")
        } description: {
            Text("Check items in the results list to build a cleanup plan.")
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - Plan

    private var planContent: some View {
        List {
            Section("Recovery Estimate") {
                LabeledContent {
                    Text(state.estimatedRecoveryBytes.formatted(.byteCount(style: .file)))
                        .fontWeight(.semibold)
                        .monospacedDigit()
                        .foregroundStyle(.green)
                } label: {
                    Text("\(state.selectedItems.count) items")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Risk Breakdown") {
                let low    = state.selectedItems.filter { $0.riskLevel == .low }.count
                let medium = state.selectedItems.filter { $0.riskLevel == .medium }.count
                let high   = state.selectedItems.filter { $0.riskLevel == .high }.count

                if low > 0    { riskRow(label: "Low",    count: low,    color: .riskLow) }
                if medium > 0 { riskRow(label: "Medium", count: medium, color: .riskMedium) }
                if high > 0   { riskRow(label: "High",   count: high,   color: .riskHigh) }
            }

            let excluded = state.results.filter {
                $0.riskLevel == .protected || $0.category == .packageOutput
            }.count

            if excluded > 0 {
                Section {
                    Label(
                        "\(excluded) item\(excluded == 1 ? "" : "s") excluded",
                        systemImage: "lock"
                    )
                    .foregroundStyle(.secondary)
                    .font(.callout)
                }
            }

            Section {
                Button {
                    // TODO: navigate to cleanup plan screen
                } label: {
                    Label("Generate Plan", systemImage: "list.bullet.clipboard")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(state.selectedItems.isEmpty)
            }
        }
        .listStyle(.sidebar)
    }

    private func riskRow(label: String, count: Int, color: Color) -> some View {
        LabeledContent {
            Text("\(count)")
                .monospacedDigit()
                .foregroundStyle(color)
        } label: {
            Label(label, systemImage: "circle.fill")
                .foregroundStyle(color)
                .font(.callout)
        }
    }
}
