import SwiftUI
import ConfettiSwiftUI

struct LoserView: View {
    private(set) var winnerName: String? = nil
    @State var startConfetti: Int = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Text("😥😥😥").font(.system(size: 80))
            Text("You Lose").font(.largeTitle)
            
            if let winnerName = winnerName {
                Text("\(winnerName) Wins")
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}
