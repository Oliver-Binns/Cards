import SwiftUI
import GroupActivities

struct MainMenu: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()

                Heading()

                Spacer()

                PlayTogetherView()

                PlaySoloView()

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
