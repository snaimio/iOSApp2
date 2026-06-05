import SwiftUI

@main
struct ScavengerApp: App {
    
    @StateObject var store = ScavengerStore()   // Creates the data store that lives for the entire app
    
    var body: some Scene {
        WindowGroup {
            
            NavigationStack {   // NavigationStack allows moving between screens
                WelcomeView()
                    .environmentObject(store)
            }
        }
    }
}
