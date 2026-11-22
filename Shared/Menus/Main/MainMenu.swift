import SwiftUI
import GroupActivities

struct MainMenu: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("FaceCards 🃏")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.semibold)
                
                Spacer()
                
                PlaySoloView()
                
                PlayTogetherView()
                
                Spacer()
            }
            .readableGuidePadding()
            .padding()
            .background(Color.dynamicGreen)
        }
        .inlineNavigationTitle()
        .accentColor(.primary)
    }
    
}
