import SwiftUI

struct PlaySoloView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink {
                SoloGame()
            } label: {
                Label("Play Solo", systemImage: "person")
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    PlaySoloView()
}
