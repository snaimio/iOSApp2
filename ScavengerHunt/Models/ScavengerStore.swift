import SwiftUI
import Combine

// This class holds all the data for the scavenger hunt app
// ObservableObject allows SwiftUI to watch for changes

class ScavengerStore: ObservableObject {
    
    // @Published means when items change, the UI updates automatically
    // All 10 scavenger hunt items with their names and clues
    
    @Published var items: [ScavengerItem] = [
        ScavengerItem(name: "Coffee Shop", clue: "Smells like fresh coffee beans"),
        ScavengerItem(name: "Movie Theater", clue: "Where movies come to life on big screen"),
        ScavengerItem(name: "Book Store", clue: "A quiet place full of stories and knowledge"),
        ScavengerItem(name: "Restaurant", clue: "Food lovers gather here for delicious meals"),
        ScavengerItem(name: "Library", clue: "Silent reading paradise with thousands of books"),
        ScavengerItem(name: "Gym", clue: "Where people go to stay fit and healthy"),
        ScavengerItem(name: "Park", clue: "Green space for relaxing and outdoor fun"),
        ScavengerItem(name: "Bakery", clue: "Follow the smell of fresh bread and pastries"),
        ScavengerItem(name: "Mall", clue: "Shopping paradise with many stores together"),
        ScavengerItem(name: "Ice Cream Shop", clue: "Cold sweet treats on a hot day")
    ]
    
    // Computed property that counts how many items have been found
    // Filters the array and returns the count where isFound is true
    
    var foundCount: Int {
        items.filter { $0.isFound }.count
    }
    
    // Returns the reward message based on how many items were found
    // 5 items = 10% discount, 7 items = 20% discount, 10 items = grand prize entry
    
    var rewardMessage: String {
        if foundCount == 10 {
            return "🏆 $5,000 GRAND PRIZE ENTRY! + 20% Discount Code"
        } else if foundCount >= 7 {
            return "💰💰 20% Discount Code"
        } else if foundCount >= 5 {
            return "💰 10% Discount Code"
        } else {
            return "🔎 Keep searching! Need \(5 - foundCount) more for discount"
        }
    }
    
    // Helper function to find the index of a specific item by its unique ID
    // Returns nil if the item is not found
    
    func index(for item: ScavengerItem) -> Int? {
        items.firstIndex { $0.id == item.id }
    }
}
