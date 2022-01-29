import SwiftUI

struct WinnerView: View {
    let winner: String
    
    var body: some View {
        VStack {
            Text("\(winner) Wins")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}
