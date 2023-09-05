import SwiftUI
import GroupActivities

struct MainMenu: View {
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Face Cards 🃏")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.semibold)
                
                Spacer()
                
                SelectGame()
                
                Spacer()
            }
            .readableGuidePadding()
            .padding()
            .background(Color.dynamicGreen)
            .navigationDestination(unwrapping: $model.game) { game in
                GameView(game: game)
            }
            .navigationDestination(unwrapping: $model.error) { error in
                ErrorView()
            }
        }
        .inlineNavigationTitle()
        .accentColor(.primary)
    }
    
}
