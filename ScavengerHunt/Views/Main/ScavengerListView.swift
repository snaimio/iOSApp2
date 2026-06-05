import SwiftUI

struct ScavengerListView: View {
    @EnvironmentObject var store: ScavengerStore
    @State private var selectedItem: ScavengerItem?
    @State private var showSubmitAlert = false
    @State private var showResetAlert = false
    
    // Grid with 2 columns
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Progress header
            VStack(spacing: 6) {
                Text("Found: \(store.foundCount) / 10")
                    .font(.headline)
                    .fontWeight(.bold)
                
                // Progress bar
                ProgressView(value: Double(store.foundCount), total: 10)
                    .tint(.mint)
                    .frame(height: 6)
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    .padding(.horizontal)
                
                // Reward message
                Text(store.rewardMessage)
                    .font(.subheadline)
                    .foregroundColor(store.foundCount >= 5 ? .mint : .gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            
            // Buttons row
            HStack(spacing: 12) {
                // Submit button
                Button(action: { showSubmitAlert = true }) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Submit")
                        if store.foundCount >= 5 {
                            Text("\(store.foundCount >= 7 ? "20%" : "10%")")
                                .font(.caption2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(store.foundCount >= 5 ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(store.foundCount < 5)
                
                // Reset button
                Button(action: { showResetAlert = true }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Reset")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Alert for submit
            .alert("Submit Results", isPresented: $showSubmitAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(store.rewardMessage)
            }
            
            // Alert for reset
            .alert("Reset Game?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetGame()
                }
            } message: {
                Text("All progress and photos will be lost.")
            }
            
            // Grid of items
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(store.items) { item in
                        ItemCard(item: item)
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                }
                .padding(12)
            }
        }
        .navigationTitle("Scavenger Hunt")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedItem) { item in
            if let index = store.index(for: item) {
                ScavengerDetailView(item: $store.items[index])
            }
        }
    }
    
    // Reset all progress
    func resetGame() {
        for i in 0..<store.items.count {
            store.items[i].isFound = false
            store.items[i].image = nil
        }
    }
}

// Card view for each item in the grid
struct ItemCard: View {
    let item: ScavengerItem
    
    var body: some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 12)
                .fill(item.isFound ? Color.mint.opacity(0.25) : Color.gray.opacity(0.12))
                .aspectRatio(0.9, contentMode: .fit)
                .overlay(
                    VStack(spacing: 6) {
                        // Status icon
                        Image(systemName: item.isFound ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundColor(item.isFound ? .mint : .gray)
                        
                        // Item name
                        Text(item.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 4)
                        
                        // Clue
                        Text(item.clue)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 4)
                        
                        // Camera icon if photo taken
                        if item.image != nil {
                            Image(systemName: "camera.fill")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(8)
                )
        }
    }
}

#Preview {
    NavigationStack {
        ScavengerListView()
            .environmentObject(ScavengerStore())
    }
}
