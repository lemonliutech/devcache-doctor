import SwiftUI
import DevStorageCore

struct ScanResultListView: View {
    @Environment(AppState.self) private var state

    private let toolchainOrder = [
        "Xcode / iOS",
        "Android / Gradle",
        "Flutter / Dart / FVM",
        "CocoaPods",
        "Node / pnpm / npm",
        "HarmonyOS / DevEco",
    ]

    private var toolchains: [String] {
        let inResults = Set(state.results.map(\.toolchain))
        var ordered = toolchainOrder.filter { inResults.contains($0) }
        let extras = inResults.subtracting(toolchainOrder).sorted()
        ordered.append(contentsOf: extras)
        return ordered
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(toolchains, id: \.self) { toolchain in
                    ToolchainSectionView(
                        toolchain: toolchain,
                        items: state.items(for: toolchain),
                        selectedIDs: Binding(
                            get: { state.selectedItemIDs },
                            set: { _ in }
                        ),
                        onToggle: { item in state.toggleSelection(item) }
                    )
                }
            }
        }
    }
}

// MARK: - Toolchain Section

struct ToolchainSectionView: View {
    let toolchain: String
    let items: [StorageItem]
    @Binding var selectedIDs: Set<String>
    let onToggle: (StorageItem) -> Void

    @State private var isExpanded = true

    private var totalBytes: UInt64 {
        items.compactMap(\.sizeBytes).reduce(0, +)
    }

    private var selectedCount: Int {
        items.filter { selectedIDs.contains($0.id) }.count
    }

    var body: some View {
        Section {
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(items) { item in
                        StorageItemRowView(
                            item: item,
                            isSelected: selectedIDs.contains(item.id),
                            onToggle: { onToggle(item) }
                        )
                        Divider()
                            .background(Color.borderSubtle)
                            .padding(.leading, Spacing.medium + 20 + Spacing.base)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        } header: {
            sectionHeader
        }
    }

    private var sectionHeader: some View {
        HStack {
            Image(systemName: iconName(for: toolchain))
                .font(.system(size: 13))
                .foregroundStyle(Color.textSecondary)
                .frame(width: 16)

            Text(toolchain)
                .font(.bodySmall)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text("\(items.count) items · \(formatBytes(totalBytes))")
                .font(.caption)
                .foregroundStyle(Color.textMuted)

            if selectedCount > 0 {
                Text("· \(selectedCount) selected")
                    .font(.caption)
                    .foregroundStyle(Color.accentPrimary)
            }

            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                .font(.caption)
                .foregroundStyle(Color.textMuted)
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(Color.bgSurface)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.standard) {
                isExpanded.toggle()
            }
        }
    }

    private func iconName(for toolchain: String) -> String {
        switch toolchain {
        case "Xcode / iOS":          return "hammer"
        case "Android / Gradle":     return "cpu"
        case "Flutter / Dart / FVM": return "wind"
        case "CocoaPods":            return "shippingbox"
        case "Node / pnpm / npm":    return "network"
        case "HarmonyOS / DevEco":   return "square.stack.3d.up"
        default:                     return "folder"
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
