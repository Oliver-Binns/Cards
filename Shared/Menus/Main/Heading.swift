import SwiftUI

struct Heading: View {
    var body: some View {
        HStack(alignment: .bottom) {
            Text("Face\nCards")
                .foregroundStyle(Color.accentColor)
                .font(.system(size: 50, design: .serif))
                .fontWeight(.bold)

            Image("Cards")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 130)
        }
    }
}

#Preview {
    VStack {
        Heading()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background { FeltBackground() }
}
