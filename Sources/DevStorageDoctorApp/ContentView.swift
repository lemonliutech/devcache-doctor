import SwiftUI

struct ContentView: View {
    @State private var sidebarSelection: SidebarItem? = .overview
    @Environment(AppState.self) private var state

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $sidebarSelection)
        } content: {
            detailView
                .navigationSplitViewColumnWidth(min: 480, ideal: 640)
        } detail: {
            CleanupPlanPanelView()
                .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 260)
        }
        .preferredColorScheme(.dark)
        .frame(minWidth: 780, minHeight: 520)
    }

    @ViewBuilder
    private var detailView: some View {
        switch sidebarSelection ?? .overview {
        case .overview:
            OverviewView()
        case .settings:
            SettingsPlaceholderView()
        case .reports:
            ReportsPlaceholderView()
        default:
            if let toolchain = sidebarSelection?.toolchainKey {
                ToolchainDetailView(toolchain: toolchain)
            } else {
                OverviewView()
            }
        }
    }
}

// MARK: - Placeholder views (to be replaced in subsequent tasks)

struct ToolchainDetailView: View {
    let toolchain: String
    @Environment(AppState.self) private var state

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(toolchain)
                    .font(.headingSmall)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
            }
            .padding(Spacing.medium)
            .background(Color.bgSurface)

            Divider().background(Color.borderSubtle)

            let items = state.items(for: toolchain)
            if items.isEmpty {
                emptyToolchain
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(items) { item in
                            StorageItemRowView(
                                item: item,
                                isSelected: state.selectedItemIDs.contains(item.id),
                                onToggle: { state.toggleSelection(item) }
                            )
                            Divider().background(Color.borderSubtle)
                                .padding(.leading, 52)
                        }
                    }
                }
            }
        }
    }

    private var emptyToolchain: some View {
        VStack(spacing: Spacing.base) {
            Image(systemName: "tray")
                .font(.system(size: 32))
                .foregroundStyle(Color.textMuted)
            Text("No \(toolchain) storage detected")
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SettingsPlaceholderView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.headingSmall)
                .foregroundStyle(Color.textPrimary)
            Text("Coming in a future task")
                .font(.bodySmall)
                .foregroundStyle(Color.textMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ReportsPlaceholderView: View {
    var body: some View {
        VStack {
            Text("Reports")
                .font(.headingSmall)
                .foregroundStyle(Color.textPrimary)
            Text("Coming in a future task")
                .font(.bodySmall)
                .foregroundStyle(Color.textMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
