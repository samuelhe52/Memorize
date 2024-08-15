//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    private(set) var cards: [Card]
    private static func generateCards(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) -> [Card] {
        var tmpCards: [Card] = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            tmpCards.append(Card(content: content, id: Card.ID(description: "\(pairIndex + 1)a")))
            tmpCards.append(Card(content: content, id: Card.ID(description: "\(pairIndex + 1)b")))
        }
        
        return tmpCards.shuffled()
    }
    
    init(numberOfPairsOfCards number: Int, cardContentFactory: (Int) -> CardContent) {
        cards = MemoryGame<CardContent>.generateCards(numberOfPairsOfCards: number, cardContentFactory: cardContentFactory)
    }
    
    var theOneAndOnlyFaceUpCardIndex: Int? {
        get { return cards.indices.filter { cards[$0].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    private(set) var score: Int = 0
    
    mutating func chooseCard(_ card: Card) {
        if let chosenCardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenCardIndex].isFaceUp && !cards[chosenCardIndex].isMatched {
                if let potentialMatchIndex = theOneAndOnlyFaceUpCardIndex {
                    if cards[chosenCardIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenCardIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2 + cards[chosenCardIndex].bonus + cards[potentialMatchIndex].bonus
                        print("Matched: \"\(cards[chosenCardIndex])\" and \"\(cards[potentialMatchIndex])\"")
                    } else {
                        print("Seen: \(cards[chosenCardIndex].seen)")
                        if cards[chosenCardIndex].seen == true {
                            score -= 1
                        }
                        print("Match failed: \"\(cards[chosenCardIndex])\" and \"\(cards[potentialMatchIndex])\"")
                    }
                } else {
                    print("Seen: \(cards[chosenCardIndex].seen)")
                    if cards[chosenCardIndex].seen == true {
                        score -= 1
                    }
                    theOneAndOnlyFaceUpCardIndex = chosenCardIndex
                }
                cards[chosenCardIndex].isFaceUp = true
            }
        }
    }
    
    mutating func changeTheme(numberOfPairsOfCards number: Int, cardContentFactory: (Int) -> CardContent) {
        cards = MemoryGame<CardContent>.generateCards(numberOfPairsOfCards: number, cardContentFactory: cardContentFactory)
    }
    
    mutating func startNewGame() {
        cards.indices.forEach { cards[$0].resetCardState() }
        score = 0
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    seen = true
                }
            }
        }
        
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        
        let content: CardContent
        var seen: Bool = false
        
        struct CardID: Hashable {
            let description: String
        }
        
        var id: CardID
        var debugDescription: String {
            return "\(id.description): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "not matched")"
        }
        
        mutating func resetCardState() {
            self.isFaceUp = false
            self.isMatched = false
            self.seen = false
        }
        
        // MARK: - Bonus Time
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
    }
}

extension Array {
    var only: Element? {
        self.count == 1 ? self.first : nil
    }
}
