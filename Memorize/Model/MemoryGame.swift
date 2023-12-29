//
//  MemoryGame.swift
//  Memorize
//
//  Created by Данік on 01/03/2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    // private(set) means that other classes can look at it but can't change it
    private(set) var cards: Array<Card>
    
    private var indexOfTheONeAndOnlyFaceUpCard: Int? {
        // filter through all the cards and give the first and only element of the array
        get { cards.indices.filter ({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue)}
        }
    }
    
    mutating func choose(_ card: Card) {
        // find the index of the chosen card in the array of cards
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp, // card should not already be face up i.e. tap two times at one card
           !cards[chosenIndex].isMatched // card should not already be matched
        {
            // check if there is already a face-up card i.e. if the indexOfTheONeAndOnlyFaceUpCard not nill
            if let potentialMatchIndex = indexOfTheONeAndOnlyFaceUpCard {
                // there is one card that is face up
                // check if the chosen card and the one that was chosen previously match
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                // mark the chosen card as the one and only face-up card
                indexOfTheONeAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        // create an empty array of cards
        cards = []
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            // reset the face-up card index
            return nil
        }
    }
}
