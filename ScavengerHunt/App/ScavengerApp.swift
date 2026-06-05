import SwiftUI

// App entry point, this is where the app starts

@main
struct ScavengerApp: App {
    
    // Creates the data store that lives for the entire app
    // @StateObject means SwiftUI keeps it alive and watches for changes
    
    @StateObject var store = ScavengerStore()
    
    var body: some Scene {
        WindowGroup {
            
            // NavigationStack enables navigation between screens (Game -> Welcome)
            // It also automatically provide a back button when we nevigate to a new view
            
            NavigationStack {
                
                // Welcome screen is the first screen users see
                
                WelcomeView()
                
                    // Passes the data store to all child views
                
                    .environmentObject(store)
            }
        }
    }
}
