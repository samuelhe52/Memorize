//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import Foundation

struct MemoryGame<CardContent> {
    private(set) var cards: [Card]
    private static func generateCards(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) -> [Card] {
        var tmpCards: [Card] = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            tmpCards.append(Card(content: content))
            tmpCards.append(Card(content: content))
        }
        
        return tmpCards
    }

    init(numberOfPairsOfCards number: Int, cardContentFactory: (Int) -> CardContent) {
        cards = MemoryGame<CardContent>.generateCards(numberOfPairsOfCards: number, cardContentFactory: cardContentFactory)
    }
    
    func chooseCard(card: Card) {
        
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }
    
    mutating func changeTheme(numberOfPairsOfCards number: Int, cardContentFactory: (Int) -> CardContent) {
        cards = MemoryGame<CardContent>.generateCards(numberOfPairsOfCards: number, cardContentFactory: cardContentFactory)
    }
    
    struct Card {
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
    }
}
