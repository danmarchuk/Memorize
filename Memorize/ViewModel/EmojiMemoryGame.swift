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
    
    static let emojis = ["✊🏿", "💆🏿‍♀️", "🙎🏿‍♀️", "💇🏿‍♀️", "🧖🏿‍♂️", "💅🏿", "🤦🏿‍♂️", "🙇🏿", "🤱🏿", "🙋🏿‍♀️", "🧝‍♀️", "🩲", "👗", "👠", "👑", "🐰", "🐸", "🐰", "🐝", "🐭", "🐹", "🐌"]
    
    
    func makeCardContent(index: Int) -> String {
        return "🐵"
    }
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 12) { index in
            emojis[index]
        }
    }
    
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
