import SwiftUI

struct GameButton: View {
    let imageName: String
    let name: String
    let players: ClosedRange<Int>
    let action: () -> Void
    
    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: imageName)
                    .font(.largeTitle)
                Text(name)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                
                HStack(spacing: 0) {
                    Image(systemName: "person.fill")
                    Text("\(players.lowerBound)" + (players.lowerBound == players.upperBound ? "" : "-\(players.upperBound)"))
                        .fontWeight(.semibold)
                }
                .font(.caption)
                .foregroundColor(.primary)
            }.padding()
        }
        .foregroundColor(.red)
        .background(.background)
        .cornerRadius(8)
        .shadow(radius: 4)
        .opacity(isEnabled ? 1 : 0.7)
    }
}

struct GameButton_Previews: PreviewProvider {
    static var previews: some View {
        GameButton(imageName: "", name: "", players: 2...5, action: { })
    }
}
