import SwiftUI

struct PlaySoloView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink {
                SoloGame()
            } label: {
                Label("Play Solo", systemImage: "person")
                    .font(.body.weight(.semibold))
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .outlinedButtonBorder(Color(.accent), lineWidth: 1.5)
        }
    }
}

#Preview {
    PlaySoloView()
}
