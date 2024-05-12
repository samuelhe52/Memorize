//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let halloweenTheme: [String] = ["👻", "🎃", "💀", "🕷️", "👿", "🕸️","🐙", "🐍", "😵", "🙀", "🍬", "🧺"]
    private static let animalTheme: [String] = ["🐶", "🐭", "🐹", "🐰", "🦊", "🐻", "🐻‍❄️", "🐨", "🦁", "🐮", "🐷", "🐵"]
    private static let digitalTheme: [String] = ["⌚️", "📱", "💻", "⌨️", "🖥️", "🖨️", "⏰", "🎙️", "📺", "📽️", "📻", "🧭"]
    static let availableThemes: [String: (Color, [String])] = ["Halloween": (.purple, halloweenTheme), "Animal": (.pink, animalTheme), "Digital": (.blue, digitalTheme)]
        
    @Published private var memoryGame = makeMemoryGame()
    
    private static func makeMemoryGame(memoryGameTheme theme: String = "Halloween") -> MemoryGame<String> {
        let themeEmojis = availableThemes[theme]?.1 ?? halloweenTheme
        
        return MemoryGame(numberOfPairsOfCards: themeEmojis.count) { pairIndex in
            if themeEmojis.indices.contains(pairIndex) {
                return themeEmojis[pairIndex]
            } else {
                return "❌"
            }
        }
    }
    
    var currentColor: Color = .purple
    
    var cards: Array<MemoryGame<String>.Card> {
        return memoryGame.cards
    }
    
    // MARK: - Intent
    
    func choose(card: MemoryGame<String>.Card) {
        memoryGame.chooseCard(card: card)
    }
    
    func shuffleCards() {
        memoryGame.shuffleCards()
    }
    
    func changeTheme(to theme: String) {
        let themeEmojis = EmojiMemoryGame.availableThemes[theme]?.1 ?? EmojiMemoryGame.halloweenTheme
        
        func makeCardContent(pairIndex: Int) -> String {
            if themeEmojis.indices.contains(pairIndex) {
                return themeEmojis[pairIndex]
            } else {
                return "❌"
            }
        }
        
        currentColor = EmojiMemoryGame.availableThemes[theme]?.0 ?? .purple
        memoryGame.changeTheme(numberOfPairsOfCards: themeEmojis.count, cardContentFactory: makeCardContent)
    }
}
