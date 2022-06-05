import SwiftUI

@main
struct MegaMapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppManager(user: .empty()))
        }
    }
}
