import SwiftUI
import GroupActivities

struct MainMenu: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Face Cards 🃏")
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
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(.primary)
    }
    
}
