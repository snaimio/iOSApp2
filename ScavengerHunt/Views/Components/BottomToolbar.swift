import SwiftUI

// Component for action buttons at the bottom

struct BottomToolbar: View {
    @Binding var hasMarkedFound: Bool
    @Binding var isComplete: Bool
    @Binding var showPhotoWarning: Bool
    var onMarkFound: () -> Void
    var onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Mark as Found button
            
            Button(action: onMarkFound) {
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
            
            // Done button
            
            Button(action: onDone) {
                Text("Done")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isComplete ? Color.purple : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
