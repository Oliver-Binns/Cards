import SwiftUI
import GroupActivities

struct MainMenu: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Heading()

                Spacer()

                PlaySoloView()

                PlayTogetherView()

                Spacer()
            }
            .readableGuidePadding()
            .padding()
            .background { FeltBackground() }
        }
        .inlineNavigationTitle()
    }
}

#Preview {
    MainMenu()
}
