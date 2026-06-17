import Foundation
import DevStorageCore

// MARK: - Sidebar Navigation

enum SidebarItem: String, CaseIterable, Identifiable {
    case overview    = "Overview"
    case xcodeIOS    = "Xcode / iOS"
    case android     = "Android / Gradle"
    case flutter     = "Flutter / Dart / FVM"
    case cocoapods   = "CocoaPods"
    case node        = "Node / pnpm / npm"
    case harmonyos   = "HarmonyOS / DevEco"
    case manual      = "Manual Review"
    case reports     = "Reports"
    case settings    = "Settings"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .overview:   return "gauge.with.dots.needle.bottom.50percent"
        case .xcodeIOS:   return "hammer"
        case .android:    return "androidfill"
        case .flutter:    return "wind"
        case .cocoapods:  return "shippingbox"
        case .node:       return "network"
        case .harmonyos:  return "cpu"
        case .manual:     return "questionmark.folder"
        case .reports:    return "doc.text"
        case .settings:   return "gearshape"
        }
    }

    var toolchainKey: String? {
        switch self {
        case .xcodeIOS:  return "Xcode / iOS"
        case .android:   return "Android / Gradle"
        case .flutter:   return "Flutter / Dart / FVM"
        case .cocoapods: return "CocoaPods"
        case .node:      return "Node / pnpm / npm"
        case .harmonyos: return "HarmonyOS / DevEco"
        default:         return nil
        }
    }
}

// MARK: - Scan State

enum ScanPhase: Equatable {
    case idle
    case scanning
    case done
    case failed(String)
}

// MARK: - App State

@MainActor
@Observable
final class AppState {
    var scanPhase: ScanPhase = .idle
    var results: [StorageItem] = []
    var selectedItemIDs: Set<String> = []
    var projectRoots: [URL] = []
    var lastScanDate: Date?

    var selectedItems: [StorageItem] {
        results.filter { selectedItemIDs.contains($0.id) }
    }

    var estimatedRecoveryBytes: UInt64 {
        selectedItems.compactMap(\.sizeBytes).reduce(0, +)
    }

    var exceptions: [StorageItem] {
        results.filter { $0.status == .failed }
    }

    func toggleSelection(_ item: StorageItem) {
        guard item.status == .found,
              item.riskLevel != .protected,
              item.riskLevel != .unsupported,
              item.category != .packageOutput else { return }
        if selectedItemIDs.contains(item.id) {
            selectedItemIDs.remove(item.id)
        } else {
            selectedItemIDs.insert(item.id)
        }
    }

    func runScan() {
        scanPhase = .scanning
        results = []
        selectedItemIDs = []

        Task {
            let home = FileManager.default.homeDirectoryForCurrentUser
            let rules = DefaultRuleFactory.defaultRules(
                homeDirectory: home,
                projectRoots: projectRoots
            )
            let scanner = DevelopmentStorageScanner(rules: rules)
            let items = scanner.scan()

            results = items
            selectedItemIDs = Set(
                items.filter { $0.defaultSelected && $0.status == .found }.map(\.id)
            )
            lastScanDate = Date()
            scanPhase = .done
        }
    }

    func items(for toolchain: String) -> [StorageItem] {
        results.filter { $0.toolchain == toolchain }
    }

    func totalSize(for toolchain: String) -> UInt64 {
        items(for: toolchain).compactMap(\.sizeBytes).reduce(0, +)
    }
}
