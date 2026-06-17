import SwiftUI

struct OverviewView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        VStack(spacing: 0) {
            toolbar

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    DiskPressureSummaryView(results: state.results)
                        .padding(.horizontal, Spacing.medium)
                        .padding(.top, Spacing.medium)

                    switch state.scanPhase {
                    case .idle:
                        idleState
                    case .scanning:
                        scanningState
                    case .done:
                        ScanResultListView()
                    case .failed(let msg):
                        failedState(msg)
                    }
                }
            }
        }
    }

    // MARK: - Toolbar

    private var toolbar: some View {
        VStack(spacing: 0) {
            HStack {
                switch state.scanPhase {
                case .scanning:
                    ProgressView()
                        .scaleEffect(0.6)
                        .padding(.trailing, 4)
                    Text("Scanning…")
                        .font(.bodySmall)
                        .foregroundStyle(Color.textSecondary)
                case .done:
                    if let date = state.lastScanDate {
                        Text("Last scan: \(date.formatted(date: .omitted, time: .shortened))")
                            .font(.caption)
                            .foregroundStyle(Color.textMuted)
                    }
                default:
                    EmptyView()
                }

                Spacer()

                Button {
                    state.runScan()
                } label: {
                    Label(
                        state.scanPhase == .idle ? "Scan" : "Rescan",
                        systemImage: "arrow.clockwise"
                    )
                    .font(.bodySmall)
                }
                .disabled(state.scanPhase == .scanning)
                .keyboardShortcut("r", modifiers: .command)
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.small)
            .background(Color.bgSurface)
            Divider().background(Color.borderSubtle)
        }
    }

    // MARK: - States

    private var idleState: some View {
        VStack(spacing: Spacing.large) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 48))
                .foregroundStyle(Color.textMuted)
            VStack(spacing: Spacing.small) {
                Text("Ready to scan")
                    .font(.headingSmall)
                    .foregroundStyle(Color.textPrimary)
                Text("Press Scan to measure your development storage.")
                    .font(.bodySmall)
                    .foregroundStyle(Color.textSecondary)
            }
            Button("Scan Now") { state.runScan() }
                .buttonStyle(.borderedProminent)
                .tint(Color.accentPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    private var scanningState: some View {
        VStack(spacing: Spacing.large) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Measuring development storage…")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    private func failedState(_ message: String) -> some View {
        VStack(spacing: Spacing.large) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(Color.riskHigh)
            VStack(spacing: Spacing.small) {
                Text("Scan could not complete")
                    .font(.headingSmall)
                    .foregroundStyle(Color.textPrimary)
                Text(message)
                    .font(.bodySmall)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            Button("Retry Scan") { state.runScan() }
                .buttonStyle(.borderedProminent)
                .tint(Color.accentPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}
