import SwiftUI

// Conforms to Identifiable to work with ForEach and fullScreenCover(item:)

struct ScavengerItem: Identifiable {
    
    // Unique identifier, required by Identifiable protocol
    
    let id = UUID()
    
    // Business name (e.g., "Coffee Shop", "Movie Theater")
    
    var name: String
    
    // Clue to help user find the item
    
    var clue: String
    
    // Tracks whether user has found this item
    
    var isFound: Bool = false
    
    // UIImage works with camera and photo library
    // Also used for displaying stickers/business logos
    
    var image: UIImage? = nil
}
