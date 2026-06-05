import SwiftUI

// Conforms to Identifiable to work with ForEach and fullScreenCover(item:)

struct ScavengerItem: Identifiable {
    
    let id = UUID()             // Unique identifier, required by Identifiable protocol
    var name: String            // Business name (e.g., "Coffee Shop", "Movie Theater")
    var clue: String            // Clue to help user find the item
    var isFound: Bool = false   // Tracks whether user has found this item
    var image: UIImage? = nil   // UIImage works with camera, photo library, displaying stickers/business logos
}
