//
//  ScavengerDetailView.swift
//  ScavengerHunt
//

import SwiftUI
import PhotosUI

struct ScavengerDetailView: View {
    @Binding var item: ScavengerItem
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var photoScale: CGFloat = 1.0
    @State private var photoRotation: Angle = .zero
    
    let photoSize: CGFloat = 250
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Item name
                        Text(item.name)
                            .font(.system(size: 28, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                        
                        // Status text - reads directly from item
                        if item.isFound && item.image != nil {
                            Text("🎉 You found it! You may keep exploring!")
                                .font(.subheadline)
                                .foregroundColor(.mint)
                                .padding(8)
                                .background(Color.mint.opacity(0.2))
                                .cornerRadius(8)
                        } else if item.image != nil && !item.isFound {
                            Text("📷 Photo taken! Now tap 'Mark as Found'")
                                .font(.subheadline)
                                .foregroundColor(.teal)
                        } else if item.isFound && item.image == nil {
                            Text("⚠️ Marked found! Need photo")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        } else {
                            Text("⚠️ Need photo AND mark as found")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // Clue section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("🔍 CLUE")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(item.clue)
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        // Photo section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("📸 PHOTO PROOF")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if let image = item.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: photoSize, height: photoSize)
                                    .cornerRadius(12)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .scaleEffect(photoScale)
                                    .rotationEffect(photoRotation)
                                    .gesture(
                                        SimultaneousGesture(
                                            MagnificationGesture()
                                                .onChanged { value in photoScale = value }
                                                .onEnded { _ in withAnimation { photoScale = 1.0 } },
                                            RotationGesture()
                                                .onChanged { angle in photoRotation = angle }
                                                .onEnded { _ in withAnimation { photoRotation = .zero } }
                                        )
                                    )
                                    .onTapGesture(count: 2) {
                                        withAnimation {
                                            photoScale = 1.0
                                            photoRotation = .zero
                                        }
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray5))
                                    .frame(width: photoSize, height: photoSize)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .overlay(
                                        VStack {
                                            Image(systemName: "camera.viewfinder")
                                                .font(.largeTitle)
                                                .foregroundColor(.gray)
                                            Text("No photo yet")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Take Photo button
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            HStack {
                                Image(systemName: item.image != nil ? "camera.fill" : "camera")
                                Text(item.image != nil ? "✓ Photo Taken" : "Take Photo")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(item.image != nil ? Color.mint : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(item.image != nil)
                        .onChange(of: selectedItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    await MainActor.run {
                                        item.image = uiImage
                                        selectedItem = nil
                                    }
                                }
                            }
                        }
                        
                        // Mark as Found button - saves immediately to item
                        Button(action: {
                            item.isFound = true
                        }) {
                            HStack {
                                Image(systemName: item.isFound ? "checkmark.seal.fill" : "checkmark.seal")
                                Text(item.isFound ? "✓ Marked Found" : "Mark as Found")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(item.isFound ? Color.mint : Color.brown)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(item.isFound)
                        
                        // Done button - ONLY works if BOTH are done
                        // But Close button can be used anytime
                        Button(action: {
                            if item.image != nil && item.isFound {
                                dismiss()
                            }
                        }) {
                            Text("Done")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background((item.image != nil && item.isFound) ? Color.purple : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding()
                }
            }
            .navigationTitle((item.image != nil && item.isFound) ? "✓ Complete!" : item.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Close button - always works, saves nothing automatically
                // But item.isFound and item.image are already saved when user taps buttons
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.mint)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var testItem = ScavengerStore().items[0]
    ScavengerDetailView(item: $testItem)
}
