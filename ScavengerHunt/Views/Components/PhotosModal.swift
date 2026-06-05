import SwiftUI
import PhotosUI

// Component for selecting photos from library

struct PhotosModal: View {
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var hasPhoto: Bool
    @Binding var showPhotoWarning: Bool
    @Binding var itemImage: UIImage?
    
    var body: some View {
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
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        itemImage = uiImage
                        hasPhoto = true
                        showPhotoWarning = false
                        selectedItem = nil
                    }
                }
            }
        }
    }
}
