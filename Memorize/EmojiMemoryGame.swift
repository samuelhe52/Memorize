//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    struct MemoryGameTheme: Identifiable {
        var id: String { name }
        
        let name: String
        let emojis: [String]
        let accentColor: Color
        let symbol: String
    }

    struct EmojiMemoryGameThemes {
        static let halloween = MemoryGameTheme(name: "Halloween", emojis: ["👻", "🎃", "💀", "🕷️", "👿", "🕸️","🐙", "🐍", "😵", "🙀", "🍬", "🧺"], accentColor: .purple, symbol: "ant")
        static let animal = MemoryGameTheme(name: "Animal", emojis: ["🐶", "🐭", "🐹", "🐰", "🦊", "🐻", "🐻‍❄️", "🐨", "🦁", "🐮", "🐷", "🐵"], accentColor: .pink, symbol: "pawprint")
        static let digital = MemoryGameTheme(name: "Digital", emojis: ["⌚️", "📱", "💻", "⌨️", "🤖", "🖨️", "⏰", "🎙️", "📺", "📽️", "📻", "🧭"], accentColor: .blue, symbol: "pc")

        static let allCases: [MemoryGameTheme] = [EmojiMemoryGameThemes.animal, EmojiMemoryGameThemes.halloween, EmojiMemoryGameThemes.digital]
    }

    
    private static let defaultTheme = EmojiMemoryGameThemes.halloween
    
    private static let defaultCardPairCount = 8
        
    private static func createMemoryGame(memoryGameTheme theme: MemoryGameTheme = defaultTheme) -> MemoryGame<String> {
        let themeEmojis = theme.emojis
        
//        return MemoryGame(numberOfPairsOfCards: themeEmojis.count) { pairIndex in
        return MemoryGame(numberOfPairsOfCards: min(defaultCardPairCount, themeEmojis.count)) { pairIndex in
            if themeEmojis.indices.contains(pairIndex) {
                return themeEmojis[pairIndex]
            } else {
                return "❌"
            }
        }
    }
    
    @Published private var memoryGame = createMemoryGame()
    
    var currentColor: Color = defaultTheme.accentColor
    
    var currentTheme: MemoryGameTheme = defaultTheme
    
    var cards: Array<MemoryGame<String>.Card> {
        return memoryGame.cards
    }
    
    var isGameFinished: Bool { cards.allSatisfy { $0.isMatched == true } }
    
    // MARK: - Intent
    
    func choose(_ card: MemoryGame<String>.Card) {
        memoryGame.chooseCard(card)
    }
    
    func startNewGame() {
        memoryGame.startNewGame()
        memoryGame.score = 0
    }
    
    func changeTheme(to theme: MemoryGameTheme) {
        currentColor = theme.accentColor
        currentTheme = theme
        
        memoryGame = EmojiMemoryGame.createMemoryGame(memoryGameTheme: theme)
        print("Theme changed: \(theme)")
    }
    
    func getScore() -> String {
        return String(memoryGame.score)
    }
}
