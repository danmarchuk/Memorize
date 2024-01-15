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
    private(set) var score = 0
    
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
                    score += 2 + cards[chosenIndex].bonus +
                    cards[potentialMatchIndex].bonus
                } else {
                    if cards[chosenIndex].hasBeenSeen {
                        score -= 1
                    }
                    if cards[potentialMatchIndex].hasBeenSeen {
                        score -= 1
                    }
                }
            } else {
                // mark the chosen card as the one and only face-up card
                indexOfTheONeAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
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
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var hasBeenSeen = false
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        // the bonus erned so far (one point fo revery second the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime) / bonusTimeLimit : 0
        }
        

        
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be 0 which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // acumulated time card was face up in the past
        // i.e. not including the current time if it is currently so
        var pastFaceUpTime: TimeInterval = 0
        

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusRemaining > 0
        }
        
        // whether we are currently face up, unmatched and haven't yet used the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // call this when card transitions is to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when card goes face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
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
