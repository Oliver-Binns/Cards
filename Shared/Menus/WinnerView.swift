
import SwiftUI
import ConfettiSwiftUI

struct WinnerView: View {
    let winner: String
    @State var startConfetti: Int = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("🥳🥳🥳").font(.system(size: 80))
                Text("\(winner) Wins").font(.largeTitle)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ConfettiCannon(counter: $startConfetti,
                           confettis: [.text("♠"), .text("♥"), .text("♦"), .text("♣")],
                           repetitions: 50, repetitionInterval: 1).onAppear {
                startConfetti = 1
            }
        }
        .background(.ultraThinMaterial)
    }
}
