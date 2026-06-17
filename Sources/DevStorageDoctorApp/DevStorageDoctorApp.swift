import SwiftUI

@main
struct DevStorageDoctorApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandGroup(after: .appInfo) {
                Button("Scan") { appState.runScan() }
                    .keyboardShortcut("r", modifiers: .command)
            }
        }
    }
}
