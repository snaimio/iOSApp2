import SwiftUI

struct Constants {
    
    // App Info
    
    static let appName = "Scavenger Hunt"
    static let totalItems = 10
    
    // UI Sizes
    
    static let photoSize: CGFloat = 250
    static let cornerRadius: CGFloat = 12
    static let buttonCornerRadius: CGFloat = 10
    
    // Animation
    
    static let animationDuration: Double = 0.3
    
    // Reward thresholds
    
    static let discount10Threshold = 5
    static let discount20Threshold = 7
    static let grandPrizeThreshold = 10
    
    // Reward messages
    
    static let discount10Message = "10% Discount Code"
    static let discount20Message = "20% Discount Code"
    static let grandPrizeMessage = "$5,000 GRAND PRIZE DRAW ENTRY! + 20% Discount Code"
    
    // Grid layout
    
    static let gridSpacing: CGFloat = 12
    static let gridColumns = 2
}
