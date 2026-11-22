import CardsModel
import CardsStyle
import SwiftUI

struct SevensGuide: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header

                    OrnamentDivider()

                    VStack(alignment: .leading, spacing: 20) {
                        GuideStep(suit: .spades, title: "The deal") {
                            Text("The whole deck is dealt out between all the players. There are no jokers in Sevens.")
                        }
                        GuideStep(suit: .hearts, title: "Starting the game") {
                            Text("Whoever holds the **seven of diamonds** plays it first. No other card can be played until it is on the table.")
                        }
                        GuideStep(suit: .clubs, title: "Building the table") {
                            Text("On your turn, play one card. A **seven** can always be played to start a new suit. Otherwise, play the next card up or down from a suit already on the table: a 6")
                            + Text("♥").foregroundColor(Color(.cardRed))
                            + Text(" or 8")
                            + Text("♥").foregroundColor(Color(.cardRed))
                            + Text(" can go next to the 7")
                            + Text("♥").foregroundColor(Color(.cardRed))
                            + Text(". Aces are low and Kings are high.")
                        }
                        GuideStep(suit: .diamonds, title: "Your turn") {
                            Text("Tap a card to pick it up, then tap **Play**. Cards you can't play are dimmed. If none of your cards can be played, tap **Pass**.")
                        }
                        GuideStep(suit: .spades, title: "Winning") {
                            Text("The first player to get rid of all their cards wins.")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .readableGuidePadding()
            }
            .foregroundStyle(Color(.ink))
            .background { PaperBackground() }
            .inlineNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .tint(Color(.ink))
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Sevens")
                .font(.system(.largeTitle, design: .serif).weight(.bold))
                .accessibilityAddTraits(.isHeader)
            Text("How to Play")
                .font(.system(.title3, design: .serif).italic())
                .foregroundStyle(Color(.ink).opacity(0.75))

            CardRun()
                .padding(.top, 20)
        }
    }
}

/// A short fanned run of hearts centred on the seven, illustrating how the table builds.
private struct CardRun: View {
    private let style = DefaultStyle()
    private let suits: [Suit] = [.diamonds, .clubs, .hearts, .spades]

    var body: some View {
        HStack(spacing: -50) {
            ForEach(Array(suits.enumerated()), id: \.offset) { index, suit in
                let offset = index - suits.count / 2
                style.front
                    .image(forCard: .suited(.seven, suit))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 130)
                    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
                    .rotationEffect(.degrees(Double(offset) * 6), anchor: .bottom)
                    .offset(y: CGFloat(abs(offset)) * 4)
            }
        }
        .padding(.vertical, 12)
        .accessibilityHidden(true)
    }
}

private struct OrnamentDivider: View {
    var body: some View {
        HStack(spacing: 12) {
            line
            Text("♦")
                .font(.title3)
                .foregroundStyle(Color(.cardRed))
            line
        }
        .frame(maxWidth: 280)
        .accessibilityHidden(true)
    }

    private var line: some View {
        Rectangle()
            .fill(Color(.ink).opacity(0.3))
            .frame(height: 1)
    }
}

private struct GuideStep<Content: View>: View {
    let suit: Suit
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Text(suit.pip)
                .font(.title2)
                .foregroundStyle(suit.isRed ? Color(.cardRed) : Color(.ink))
                .frame(width: 24)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.title3, design: .serif).weight(.semibold))
                content
                    .font(.body)
                    .foregroundStyle(Color(.ink).opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private extension Suit {
    var pip: String {
        switch self {
        case .spades: "♠"
        case .hearts: "♥"
        case .clubs: "♣"
        case .diamonds: "♦"
        }
    }

    var isRed: Bool {
        self == .hearts || self == .diamonds
    }
}

#Preview("Light") {
    SevensGuide()
}

#Preview("Dark") {
    SevensGuide()
        .preferredColorScheme(.dark)
}
