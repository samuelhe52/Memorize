//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import Foundation

struct MemorizeGame<CardContent> {
    var cards: [Card]
    
    func chooseCard(card: Card) {
        
    }
    
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
    }
}
