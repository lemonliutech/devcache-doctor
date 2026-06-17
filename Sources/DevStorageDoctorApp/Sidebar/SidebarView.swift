import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem?

    private let mainItems: [SidebarItem] = [.overview, .xcodeIOS, .android, .flutter, .cocoapods, .node, .harmonyos, .manual]
    private let bottomItems: [SidebarItem] = [.reports, .settings]

    var body: some View {
        List(selection: $selection) {
            Section {
                ForEach(mainItems) { item in
                    sidebarRow(item)
                }
            }

            Section {
                ForEach(bottomItems) { item in
                    sidebarRow(item)
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 180, idealWidth: 200)
    }

    private func sidebarRow(_ item: SidebarItem) -> some View {
        Label(item.rawValue, systemImage: item.systemImage)
            .font(.bodySmall)
            .tag(item)
    }
}
