import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem?

    private let mainItems: [SidebarItem] = [
        .overview, .xcodeIOS, .android, .flutter,
        .cocoapods, .node, .harmonyos, .manual
    ]
    private let bottomItems: [SidebarItem] = [.reports, .settings]

    var body: some View {
        List(selection: $selection) {
            Section("Storage") {
                ForEach(mainItems) { item in
                    Label(item.rawValue, systemImage: item.systemImage)
                        .tag(item)
                }
            }
            Section {
                ForEach(bottomItems) { item in
                    Label(item.rawValue, systemImage: item.systemImage)
                        .tag(item)
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 180, idealWidth: 200)
    }
}
