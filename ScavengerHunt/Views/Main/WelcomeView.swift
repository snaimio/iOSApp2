import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var store: ScavengerStore
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App icon
            
            Image(systemName: "binoculars.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            // App title
            
            Text("Scavenger Hunt")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Subtitle
            
            Text("Find 10 hidden items in your city!")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Instructions
            
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.blue)
                        .frame(width: 30)
                    Text("Take a photo of each item you find")
                }
                HStack {
                    Image(systemName: "map.circle.fill")
                        .foregroundColor(.orange)
                        .frame(width: 30)
                    Text("Follow clues to discover locations")
                }
                HStack {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.green)
                        .frame(width: 30)
                    Text("Earn discounts and prizes!")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Start button - navigates to game screen
            
            NavigationLink(destination: ScavengerListView()
                .environmentObject(store)) {
                Text("Start Hunt")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
}

#Preview {
    WelcomeView()
        .environmentObject(ScavengerStore())
}
