import SwiftUI

@main
struct ScavengerApp: App {
    // Creates the data store that lives for the entire app
    @StateObject var store = ScavengerStore()
    
    var body: some Scene {
        WindowGroup {
            // NavigationStack allows moving between screens
            NavigationStack {
                WelcomeView()
                    .environmentObject(store)
            }
        }
    }
}
