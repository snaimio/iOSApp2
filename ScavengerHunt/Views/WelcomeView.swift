import SwiftUI

struct WelcomeView: View {
    
    // Access the shared data store from environment
    
    @EnvironmentObject var store: ScavengerStore
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App icon, binoculars represent searching/hunting
            
            Image(systemName: "binoculars.fill")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
            
            // App title
            
            Text("Scavenger Hunt")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Subtitle explaining the goal of the app
            
            Text("Find 10 hidden items in your city!")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Instructions list
            
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.purple)
                        .frame(width: 30)
                    Text("Take a photo of each item you find")
                }
                HStack {
                    Image(systemName: "map.circle.fill")
                        .foregroundColor(.brown)
                        .frame(width: 30)
                    Text("Follow clues to discover locations")
                }
                HStack {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.mint)
                        .frame(width: 30)
                    Text("Earn discounts and prizes!")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // NavigationLink pushes the ScavengerListView onto the navigation stack
            // When tapped, SwiftUI automatically shows a back button on the next screen
            // Button to start the game, navigates to main welcome screen
            
            NavigationLink(destination: ScavengerListView()
                .environmentObject(store)) {
                Text("Start Hunt")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.2, green: 0.5, blue: 0.8))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .padding()
        .background(
            
            // Light blue to white gradient background
            
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        
        // Hide navigation bar on welcome screen for cleaner look
        
        .navigationBarHidden(true)
    }
}

// Preview for Xcode canvas

#Preview {
    WelcomeView()
        .environmentObject(ScavengerStore())
}
