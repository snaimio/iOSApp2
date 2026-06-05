import SwiftUI

// View modifier for pinch and rotate gestures
struct ResizableView: ViewModifier {
    @Binding var scale: CGFloat
    @Binding var rotation: Angle
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .rotationEffect(rotation)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        }
                        .onEnded { _ in
                            withAnimation {
                                scale = 1.0
                            }
                        },
                    RotationGesture()
                        .onChanged { angle in
                            rotation = angle
                        }
                        .onEnded { _ in
                            withAnimation {
                                rotation = .zero
                            }
                        }
                )
            )
            .onTapGesture(count: 2) {
                withAnimation {
                    scale = 1.0
                    rotation = .zero
                }
            }
    }
}

// Extension to make it easy to use
extension View {
    func resizableView(scale: Binding<CGFloat>, rotation: Binding<Angle>) -> some View {
        modifier(ResizableView(scale: scale, rotation: rotation))
    }
}
