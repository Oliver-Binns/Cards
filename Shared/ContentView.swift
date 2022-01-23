import Cards
import SwiftUI
import GroupActivities

struct ContentView: View {
    let style = DefaultStyle()
    @State private var canShare: Bool = false
    @State private var deck = Deck.full.shuffled()
    
    let session: GroupSession<PlayTogether>? = nil
    @State var groupActivity: PlayTogether?
    
    var body: some View {
        ScrollView {
            /*if canShare {
                Button("Start SharePlay") {
                    Task {
                        do {
                            let success = try await groupActivity.activate()
                            canShare = false
                            print("success:", success)
                        } catch {
                            print(error)
                        }
                    }
                }
            }*/
            ForEach(0..<deck.count) { index in
                style.front.image(forCard: deck[index])
            }
        }
        .padding()
        .onAppear {
            Task {
                groupActivity = PlayTogether(title: "Hearts", cards: deck)
                let type = await groupActivity?.prepareForActivation()
                print("prepare", type)
                let activation = try await groupActivity?.activate()
                print("active", activation)
                for await session in PlayTogether.sessions() {
                    self.deck = session.activity.cards
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
