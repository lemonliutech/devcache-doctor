import SwiftUI
import DevStorageCore

struct StorageItemRowView: View {
    let item: StorageItem
    let isSelected: Bool
    let onToggle: () -> Void

    @State private var isExpanded = false

    private var canSelect: Bool {
        item.status == .found
            && item.riskLevel != .protected
            && item.riskLevel != .unsupported
            && item.category != .packageOutput
    }

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            expandedDetail
        } label: {
            rowLabel
        }
        .disclosureGroupStyle(PlainDisclosureStyle())
    }

    // MARK: - Collapsed label

    private var rowLabel: some View {
        HStack(spacing: Spacing.small) {
            // Selection control
            Group {
                if item.riskLevel == .protected {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.secondary)
                } else if !canSelect {
                    Image(systemName: "minus")
                        .foregroundStyle(.tertiary)
                } else {
                    Toggle("", isOn: Binding(
                        get: { isSelected },
                        set: { _ in onToggle() }
                    ))
                    .toggleStyle(.checkbox)
                    .labelsHidden()
                }
            }
            .frame(width: 18)

            // Name + short explanation
            VStack(alignment: .leading, spacing: 1) {
                Text(item.displayName)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(item.explanation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Size
            if let bytes = item.sizeBytes {
                Text(bytes.formatted(.byteCount(style: .file)))
                    .font(.callout)
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                    .frame(width: 70, alignment: .trailing)
            } else {
                Text("—")
                    .font(.callout)
                    .foregroundStyle(.tertiary)
                    .frame(width: 70, alignment: .trailing)
            }

            RiskBadgeView(riskLevel: item.riskLevel)
                .frame(width: 90, alignment: .trailing)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }

    // MARK: - Expanded detail

    private var expandedDetail: some View {
        VStack(alignment: .leading, spacing: 6) {
            detailRow("Path") {
                HStack(spacing: Spacing.tight) {
                    Text(item.path)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                        .lineLimit(2)
                    Spacer()
                    Button {
                        NSWorkspace.shared.selectFile(item.path, inFileViewerRootedAtPath: "")
                    } label: {
                        Label("Show in Finder", systemImage: "arrow.right.circle")
                            .labelStyle(.iconOnly)
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .help("Show in Finder")
                    .disabled(!FileManager.default.fileExists(atPath: item.path))
                }
            }
            detailRow("Toolchain") {
                Text(item.toolchain)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let ex = item.exception {
                detailRow("Issue") {
                    Text(ex.message)
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                detailRow("Fix") {
                    Text(ex.suggestion)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.leading, 26)
        .padding(.vertical, 4)
    }

    private func detailRow<V: View>(_ label: String, @ViewBuilder content: () -> V) -> some View {
        HStack(alignment: .top, spacing: Spacing.small) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.tertiary)
                .frame(width: 56, alignment: .trailing)
            content()
            Spacer()
        }
    }
}

// MARK: - Plain disclosure style (no arrow padding shift)

struct PlainDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            HStack {
                configuration.label
                Image(systemName: configuration.isExpanded ? "chevron.up" : "chevron.down")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.18)) {
                    configuration.isExpanded.toggle()
                }
            }

            if configuration.isExpanded {
                configuration.content
                    .transition(.opacity)
            }
        }
    }
}
