import SwiftUI
import TipKit

@available(iOS 17.0, *)
@main
struct BallotApp: App {
    
    init() {
        try? Tips.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            GeneralView()
        }
    }
}
