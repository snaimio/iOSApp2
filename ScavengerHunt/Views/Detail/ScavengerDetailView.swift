import SwiftUI
import PhotosUI

struct ScavengerDetailView: View {
    @Binding var item: ScavengerItem
    @Environment(\.dismiss) var dismiss
    
    // Stores the photo selected from PhotosPicker
    
    @State private var selectedItem: PhotosPickerItem?
    
    // For pinch and rotate gestures on photo
    
    @State private var photoScale: CGFloat = 1.0
    @State private var photoRotation: Angle = .zero
    
    // Fixed size for all photos to keep them consistent
    
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
                        
                        // Status text - shows different messages based on what user has done
                        
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
                            
                            // Show photo if user has taken one, otherwise show placeholder
                            
                            if let image = item.image {
                                
                                // User's taken photo with pinch and rotate gestures
                                
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
                                
                                // Empty placeholder when no photo taken
                                
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
                                            Text("Tap 'Take Photo' to select a photo")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Take Photo button using PhotosPicker - allows retaking photos
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            HStack {
                                Image(systemName: item.image != nil ? "camera.fill" : "camera")
                                Text(item.image != nil ? "Retake Photo" : "Take Photo")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(item.image != nil ? Color.orange : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
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
                        
                        // Mark as Found button
                        
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
                        
                        // Done button - only works if BOTH photo taken AND marked as found
                        
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
                
                // Close button - always works
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.mint)
                }
            }
        }
        .onAppear {
            print("Item name: \(item.name)")
            print("Item image is nil? \(item.image == nil)")
        }
    }
}

#Preview {
    @Previewable @State var testItem = ScavengerStore().items[0]
    ScavengerDetailView(item: $testItem)
}

