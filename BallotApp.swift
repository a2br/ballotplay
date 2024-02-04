import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                ContentView()
            } else {
                Text("Please use iOS 17.0 or later.")
            }
        }
    }
}
