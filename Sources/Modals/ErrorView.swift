import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("This game has ended")
                .font(.largeTitle)
            Text("Thank you for playing!")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.dynamicGreen)
    }
}
