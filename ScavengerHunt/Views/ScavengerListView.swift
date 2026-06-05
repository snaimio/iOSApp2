import SwiftUI

struct ScavengerListView: View {
    
    // Access the shared data store
    
    @EnvironmentObject var store: ScavengerStore
    
    // Track which item was tapped
    
    @State private var selectedItem: ScavengerItem?
    
    // Control alert popups
    
    @State private var showSubmitAlert = false
    @State private var showResetAlert = false
    
    // Grid layout with 2 columns
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header section with progress and reward
            
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
            
            // Action buttons row
            
            HStack(spacing: 12) {
                
                // Submit results button - only enabled after 5 items
                
                Button(action: {
                    showSubmitAlert = true
                }) {
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
                    .padding(.horizontal, 8)
                    .background(store.foundCount >= 5 ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.subheadline)
                }
                .disabled(store.foundCount < 5)
                
                // Reset game button
                
                Button(action: {
                    showResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Reset")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.subheadline)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Scrollable grid of items
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(store.items) { item in
                        CompactCardView(item: item)
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
        .alert("Submit Results", isPresented: $showSubmitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(store.rewardMessage)
        }
        .alert("Reset Game?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetGame()
            }
        } message: {
            Text("All progress and photos will be lost.")
        }
    }
    
    // Function to reset all progress
    
    func resetGame() {
        for i in 0..<store.items.count {
            store.items[i].isFound = false
            store.items[i].image = nil
        }
    }
}

// Card view for each item in the grid

struct CompactCardView: View {
    let item: ScavengerItem
    
    var body: some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 12)
                .fill(item.isFound ? Color.mint.opacity(0.25) : Color.gray.opacity(0.12))
                .aspectRatio(0.9, contentMode: .fit)
                .overlay(
                    VStack(spacing: 6) {
                        
                        // Status icon (circle or checkmark)
                        
                        Image(systemName: item.isFound ? "checkmark.circle" : "circle")
                            .font(.title3)
                            .foregroundColor(item.isFound ? .mint : .gray)
                        
                        // Item name
                        
                        Text(item.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 4)
                        
                        // Short clue
                        
                        Text(item.clue)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 4)
                        
                        // Camera icon if photo taken
                        
                        if item.image != nil {
                            Image(systemName: "camera")
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
