//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Данік on 01/03/2023.
//

import SwiftUI

// The ViewModes is an intermediary between the Model and the View
// only the ViewModel's code itself can see the model
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card

    var emojis: [String] = []
    
    init(emojis: [String]) {
        self.emojis = emojis
        model = EmojiMemoryGame.createMemoryGame(emojis: emojis)
    }
    
    static func createMemoryGame(emojis: [String]) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: emojis.count) { index in
            emojis[index]
        }
    }
    
    @Published private var model: MemoryGame<String> = createMemoryGame(emojis: [])
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var score: Int {
        model.score
    }
    // MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
//        for index in model.cards.indices {
//            model.cards[index].isMatched = false
//            model.cards[index].isFaceUp = false
//        }
        model = EmojiMemoryGame.createMemoryGame(emojis: emojis)
    }
}
