//
//  ScavengerListView.swift
//  ScavengerHunt
//

import SwiftUI

struct ScavengerListView: View {
    @EnvironmentObject var store: ScavengerStore
    @State private var selectedItem: ScavengerItem?
    @State private var showSubmitAlert = false
    @State private var showResetAlert = false
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 6) {
                Text("Found: \(store.foundCount) / 10")
                    .font(.headline)
                    .fontWeight(.bold)
                
                ProgressView(value: Double(store.foundCount), total: 10)
                    .tint(.mint)
                    .frame(height: 6)
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    .padding(.horizontal)
                
                Text(store.rewardMessage)
                    .font(.subheadline)
                    .foregroundColor(store.foundCount >= 5 ? .mint : .gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            
            HStack(spacing: 12) {
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
    
    func resetGame() {
        for i in 0..<store.items.count {
            store.items[i].isFound = false
            store.items[i].image = nil
        }
    }
}

struct ItemCard: View {
    let item: ScavengerItem
    
    var body: some View {
        VStack(spacing: 8) {
            
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 140)
                    .cornerRadius(12)
                    .overlay(
                        VStack {
                            HStack {
                                if item.image != nil {
                                    Image(systemName: "camera.fill")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .padding(6)
                                        .background(Color.white.clipShape(Circle()))
                                        .padding(4)
                                }
                                Spacer()
                                if item.isFound {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                        .background(Color.white.clipShape(Circle()))
                                        .padding(4)
                                }
                            }
                            Spacer()
                        }
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.12))
                    .frame(width: 160, height: 140)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "camera.viewfinder")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("No photo yet")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                if item.isFound {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                        .background(Color.white.clipShape(Circle()))
                                        .padding(4)
                                }
                            }
                            Spacer()
                        }
                    )
            }
            
            Text(item.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 4)
            
            Text(item.clue)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 4)
        }
        .frame(width: 170)
    }
}

#Preview {
    NavigationStack {
        ScavengerListView()
            .environmentObject(ScavengerStore())
    }
}

