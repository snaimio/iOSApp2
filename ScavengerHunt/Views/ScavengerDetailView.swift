import SwiftUI
import PhotosUI

struct ScavengerDetailView: View {
    
    @Binding var item: ScavengerItem
    @Environment(\.dismiss) var dismiss
    
    @State private var showPhotoWarning = false
    @State private var hasPhoto = false
    @State private var hasMarkedFound = false
    
    // For PhotosPicker, holds selected photos
    
    @State private var selectedItem: PhotosPickerItem?
    
    // Fixed photo size
    
    let photoSize: CGFloat = 250
    
    // Computed property, item is complete only if BOTH are true
    
    var isComplete: Bool {
        return hasPhoto && hasMarkedFound
    }
    
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
                        
                        // Status indicator
                        
                        if isComplete {
                            Text("🎉 You found it! You may keep exploring!")
                                .font(.subheadline)
                                .foregroundColor(.mint)
                                .padding(8)
                                .background(Color.mint.opacity(0.2))
                                .cornerRadius(8)
                        } else if hasPhoto && !hasMarkedFound {
                            Text("📷 Photo taken! Now tap 'Mark as Found'")
                                .font(.subheadline)
                                .foregroundColor(.teal)
                        } else if !hasPhoto && hasMarkedFound {
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
                        
                        // Photo section, shows real photo if available
                        
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
                                            Text("Tap 'Take Photo' to select a photo")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Warning message
                        
                        if showPhotoWarning {
                            Text("⚠️ Complete BOTH: photo AND mark as found!")
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(8)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        // Action Buttons
                        
                        VStack(spacing: 12) {
                            
                            // Take Photo button using PhotosPicker
                            
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                HStack {
                                    Image(systemName: hasPhoto ? "camera.fill" : "camera")
                                    Text(hasPhoto ? "✓ Photo Taken" : "Take Photo")
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(hasPhoto ? Color.mint : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(hasPhoto)
                            .onChange(of: selectedItem) { _, newItem in
                                
                                // Loads the selected photo
                                
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        await MainActor.run {
                                            item.image = uiImage
                                            hasPhoto = true
                                            showPhotoWarning = false
                                            selectedItem = nil  // Resets after loading
                                        }
                                    }
                                }
                            }
                            
                            // Mark as Found button
                            
                            Button(action: {
                                hasMarkedFound = true
                                showPhotoWarning = false
                            }) {
                                HStack {
                                    Image(systemName: hasMarkedFound ? "checkmark.seal.fill" : "checkmark.seal")
                                    Text(hasMarkedFound ? "✓ Marked Found" : "Mark as Found")
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(hasMarkedFound ? Color.mint : Color.brown)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(hasMarkedFound)
                            
                            // Done button (requires BOTH)
                            
                            Button(action: {
                                if isComplete {
                                    item.isFound = true
                                    dismiss()
                                } else {
                                    showPhotoWarning = true
                                }
                            }) {
                                Text("Done")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(isComplete ? Color.purple : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding()
                }
            }
            .navigationTitle(isComplete ? "✓ Complete!" : item.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // Close button
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        if isComplete {
                            item.isFound = true
                        }
                        dismiss()
                    }
                    .foregroundColor(.mint)
                }
            }
        }
        .onAppear {
            hasPhoto = item.image != nil
            hasMarkedFound = item.isFound
        }
    }
}

#Preview {
    @Previewable @State var testItem = ScavengerStore().items[0]
    ScavengerDetailView(item: $testItem)
}
