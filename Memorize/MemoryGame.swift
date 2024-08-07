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
            tmpCards.append(Card(content: content, id: CardID(description: "\(pairIndex + 1)a")))
            tmpCards.append(Card(content: content, id: CardID(description: "\(pairIndex + 1)b")))
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
    
    var score: Int = 0
    
    mutating func chooseCard(_ card: Card) {
        if let chosenCardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenCardIndex].isFaceUp && !cards[chosenCardIndex].isMatched {
                if let potentialMatchIndex = theOneAndOnlyFaceUpCardIndex {
                    if cards[chosenCardIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenCardIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
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
                cards[chosenCardIndex].seen = true
            }
        }
    }
    
    mutating func changeTheme(numberOfPairsOfCards number: Int, cardContentFactory: (Int) -> CardContent) {
        cards = MemoryGame<CardContent>.generateCards(numberOfPairsOfCards: number, cardContentFactory: cardContentFactory)
    }
    
    mutating func startNewGame() {
        cards.indices.forEach { cards[$0].resetCardState() }
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        #if DEBUG
        var isFaceUp = true
        #else
        var isFaceUp = false
        #endif
        var isMatched = false
        let content: CardContent
        var seen: Bool = false
        
        var id: CardID
        var debugDescription: String {
            return "\(id.description): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "not matched")"
        }
        
        mutating func resetCardState() {
            self.isFaceUp = false
            self.isMatched = false
            self.seen = false
        }
    }
    
    struct CardID: Hashable {
        let uuid = UUID()
        let description: String
    }
}

extension Array {
    var only: Element? {
        self.count == 1 ? self.first : nil
    }
}
