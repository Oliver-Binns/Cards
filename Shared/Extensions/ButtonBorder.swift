import SwiftUI

extension View {
    /// Strokes the button's border, matching the system's default button shape:
    /// a capsule from iOS/macOS 26, and a rounded rectangle on earlier versions.
    @ViewBuilder
    func outlinedButtonBorder(_ color: Color, lineWidth: CGFloat) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            overlay {
                Capsule()
                    .strokeBorder(color, lineWidth: lineWidth)
                    .allowsHitTesting(false)
            }
        } else {
            let radius: CGFloat = 8
            roundedButtonBorderShape(radius: radius)
                .overlay {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .strokeBorder(color, lineWidth: lineWidth)
                        .allowsHitTesting(false)
                }
        }
    }

    @ViewBuilder
    private func roundedButtonBorderShape(radius: CGFloat) -> some View {
        if #available(iOS 15.0, macOS 14.0, *) {
            buttonBorderShape(.roundedRectangle(radius: radius))
        } else {
            self
        }
    }
}
