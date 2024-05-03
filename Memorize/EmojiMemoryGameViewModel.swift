//
//  EmojiMemorizeGame.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import SwiftUI

class EmojiMemoryGameViewModel {
    private static let halloweenTheme: [String] = ["👻", "🎃", "💀", "🕷️", "👿", "🕸️","🐙", "🐍", "😵", "🙀"]
    private static let animalTheme: [String] = ["🐶", "🐭", "🐹", "🐰", "🦊", "🐻"]
    private static let digitalTheme: [String] = ["⌚️", "📱", "💻", "⌨️", "🖥️", "🖨️"]
    private static let availableThemes: [String: (Color, [String])] = ["Halloween": (.purple, halloweenTheme), "Animal": (.pink, animalTheme), "Digital": (.blue, digitalTheme)]
    
    private var memoryGame = MemoryGame(numberOfPairsOfCards: 6) { pairIndex in
        if halloweenTheme.indices.contains(pairIndex) {
            return halloweenTheme[pairIndex]
        } else {
            return "❌"
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return memoryGame.cards
    }
    
    // MARK: - Intent
    
    func choose(card: MemoryGame<String>.Card) {
        memoryGame.chooseCard(card: card)
    }
    
    func shuffle() {
        memoryGame.shuffleCards()
    }
}
