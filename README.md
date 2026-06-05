# iOSApp2 - Scavenger Hunt App

## Description

A scavenger hunt app that helps users find 10 hidden items at local businesses. Users get clues, take photos as proof, track progress, and earn discounts and prizes.

## Core Features

### Navigation & UI
- **NavigationStack** - Screen navigation between Welcome and Game screens
- **fullScreenCover** - Modal presentation for item detail view
- **.toolbar** - Custom toolbar buttons (Close, Submit, Reset)
- **PhotosPicker Modal** - System photo picker for selecting photos

### Gestures
- **Pinch Gesture (MagnificationGesture)** - Zoom in/out on photos
- **Rotate Gesture (RotationGesture)** - Rotate photos with two fingers
- **SimultaneousGesture** - Combine pinch and rotate gestures together

### Data Management
- **ScavengerStore Class** - Central data store with ObservableObject
- **@Published** - Auto-refresh UI when data changes
- **@Binding** - Two-way data binding between views
- **@EnvironmentObject** - Share data store across all views

### Assets & Design
- **AppIcon** - Custom app icon for home screen
- **LaunchColor** - Custom launch screen background color
- **10 Image Sets** - Unique photos for each scavenger item (coffee, movie, book, etc.)

### Photo Features (PhotosUI)
- **PhotosPicker** - Select photos from user's photo library
- **loadTransferable** - Async loading of selected photos
- **Task** - Background thread for photo loading
- **MainActor.run** - UI updates on main thread
- **Photo Library Permissions** - Camera and photo library access

## Game Features

- **Welcome Screen** - App introduction and instructions
- **10 Items with Clues** - Coffee Shop, Movie Theater, Book Store, Restaurant, Library, Gym, Park, Bakery, Mall, Ice Cream Shop
- **Real Photos** - Select actual photos from your device library
- **Photo Library Permissions** - Proper permission handling
- **Mark as Found** - Mark item as discovered
- **Done Button** - Requires both photo AND mark to complete
- **Close Button** - Always works (no requirements)
- **Progress Tracking** - Visual progress bar and counter
- **Reward System** - 5+ items = 10% off, 7+ items = 20% off, 10 items = $5,000 grand prize
- **Submit Results** - Get your discount code
- **Reset/Play Again** - Reset all progress and start over

## How to Run

1. Open `ScavengerHunt.xcodeproj` in Xcode
2. Select an iPhone simulator (iPhone 17 Pro or later)
3. Press `Command + R`
4. Grant photo library access when prompted

## How to Play

1. Tap **"Start Hunt"** on welcome screen
2. Tap any item to see its clue
3. Tap **"Take Photo"** → Select photo from library
4. Pinch or rotate photo to view details (gestures)
5. Tap **"Mark as Found"** then **"Done"**
6. Find 5+ items → Submit Results for discount code
7. Tap **"Reset"** to start a new game

## Technologies

- SwiftUI
- PhotosUI
- Xcode 16.2
- iOS 18

## Author

Sheikh Naim

## GitHub

https://github.com/snaimio/iOSApp2
