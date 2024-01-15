//
//  ContentView.swift
//  Memorize
//
//  Created by Данік on 22/02/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    @ObservedObject var game: EmojiMemoryGame
    var title: String?
    var cardColor: Color?
    
    init(game: EmojiMemoryGame, title: String, cardColor: Color) {
        self.game = game
        self.title = title
        self.cardColor = cardColor
    }
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            .navigationTitle(title ?? "Memory game")
            .navigationBarItems(trailing: score)
            deckBody
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func undeal(_ card: EmojiMemoryGame.Card) {
        dealt.remove(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            // divide the total time (CardConstants.dealDuration) by how many cards we have (Double(game.cards.count))
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        
        return Animation.easeOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    // deal the cards starting from the card on the top
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                // .identity means don't do any animation
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: .identity, removal: .scale))
                //                    .zIndex(zIndex(of: card))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1: 0)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.8)){
                            let scoreBeforeChoosing = game.score
                            game.choose(card)
                            let scoreChange = game.score - scoreBeforeChoosing
                            lastScoreChange = (scoreChange, causedByCardId: card.id)
                        }
                    }
            }
        }
        .foregroundColor(cardColor ?? Color.red)
    }
    
    @State private var lastScoreChange = (0, causedByCardId: 0)
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, causedByCardId: id) = lastScoreChange
        return card.id == id ? amount : 0
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(cardColor ?? Color.red)
        .onTapGesture {
            // "deal" cards
            for card in game.cards {
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation(.easeOut(duration: 0.8)){
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)){
                    //                    dealt = []
                    undeal(card)
                    game.restart()
                    
                }
            }
        }
    }
    
    var score: some View {
        Text("Score: \(game.score)")
            .animation(nil)
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.8
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees:  (1 - animatedBonusRemaining) * 360 - 90))
                            .onAppear{
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees:  (1 - card.bonusPercentRemaining) * 360 - 90))
                    }
                }
                .padding(5)
                .opacity(0.5)
                
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
        
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

#Preview {
    EmojiMemoryGameView(game: EmojiMemoryGame(emojis: ["🍑", "🤓", "😈", "🤡", "👽", "🥵"]), title: "Amongus", cardColor: .black)
}


