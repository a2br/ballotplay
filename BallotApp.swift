import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                GeneralView()
            } else {
                // Fallback on earlier versions
                Text("This page is only available on iOS 17.0 or later.")
            }
        }
    }
}
