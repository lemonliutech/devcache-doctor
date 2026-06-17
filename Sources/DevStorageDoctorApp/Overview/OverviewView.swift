import SwiftUI

struct OverviewView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        VStack(spacing: 0) {
            // Scan progress bar — only visible while scanning
            if state.scanPhase == .scanning {
                ScanProgressBarView()
            }

            switch state.scanPhase {
            case .idle:
                idleState
            case .scanning where state.results.isEmpty:
                // Haven't received any results yet — show a minimal wait state
                scanStartingState
            case .scanning, .done:
                // Show results as they stream in (scanning) or complete (done)
                VStack(spacing: 0) {
                    DiskPressureSummaryView(results: state.results)
                        .padding(Spacing.medium)
                    ScanResultListView()
                }
            case .failed(let msg):
                failedState(msg)
            }
        }
        .navigationTitle("DevStorage Doctor")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    state.runScan()
                } label: {
                    Label(
                        state.scanPhase == .idle ? "Scan" : "Rescan",
                        systemImage: "arrow.clockwise"
                    )
                }
                .disabled(state.scanPhase == .scanning)
                .keyboardShortcut("r", modifiers: .command)
            }

            if case .done = state.scanPhase, let date = state.lastScanDate {
                ToolbarItem(placement: .status) {
                    Text("Last scan: \(date.formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // MARK: - States

    private var idleState: some View {
        ContentUnavailableView {
            Label("Ready to Scan", systemImage: "magnifyingglass.circle")
        } description: {
            Text("Measure your development storage.\nNothing is deleted until you confirm.")
        } actions: {
            Button("Scan Now") { state.runScan() }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return)
        }
    }

    private var scanStartingState: some View {
        ContentUnavailableView {
            Label("Starting Scan…", systemImage: "magnifyingglass.circle")
        } description: {
            Text(state.scanningRuleName.isEmpty ? "Preparing…" : state.scanningRuleName)
                .foregroundStyle(.secondary)
        }
    }

    private func failedState(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Scan Failed", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Retry") { state.runScan() }
                .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Scan Progress Bar

struct ScanProgressBarView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        VStack(spacing: 4) {
            ProgressView(value: state.scanProgress)
                .progressViewStyle(.linear)
                .animation(.linear(duration: 0.2), value: state.scanProgress)

            HStack {
                if !state.scanningRuleName.isEmpty {
                    Text("Scanning \(state.scanningRuleName)…")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(state.scanProgressCurrent) / \(state.scanProgressTotal)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(.bar)
    }
}
