import SwiftUI

struct OverviewView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        VStack(spacing: 0) {
            switch state.scanPhase {
            case .idle:
                idleState
            case .scanning:
                scanningState
            case .done:
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

            if state.scanPhase == .scanning {
                ToolbarItem(placement: .status) {
                    ProgressView()
                        .scaleEffect(0.7)
                        .padding(.trailing, 4)
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

    private var scanningState: some View {
        ContentUnavailableView {
            Label("Scanning…", systemImage: "arrow.clockwise")
        } description: {
            Text("Measuring development storage.")
        } actions: {
            ProgressView()
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
