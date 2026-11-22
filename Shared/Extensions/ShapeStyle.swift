import SwiftUI

extension ShapeStyle where Self == RadialGradient {
    static var feltGradient: RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [
                Color(.centre),
                Color(.edge)
            ]),
            center: .center,
            startRadius: 20,
            endRadius: 450
        )
    }
}

struct FeltBackground: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            AnyView(
                RadialGradient
                    .feltGradient
                    .colorEffect(
                        ShaderLibrary.feltNoise(.float(0.06)) // Adjust 0.03–0.08 for grain strength
                    )
                    .ignoresSafeArea()
            )
        } else {
            AnyView(RadialGradient.feltGradient)
        }
    }
}
