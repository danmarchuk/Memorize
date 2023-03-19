//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Данік on 01/03/2023.
//

import SwiftUI

// The ViewModes is an intermediary between the Model and the View
class EmojiMemoryGame {
    
    func makeCardContent(index: Int) -> String {
        return "🐵"
    }
    
    // only the ViewModel's code itself can see the model
    private var model: MemoryGame<String> =
    MemoryGame<String>(numberOfPairsOfCards: 12) { index in
        "🐵"
        
    }
    
    
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
}
