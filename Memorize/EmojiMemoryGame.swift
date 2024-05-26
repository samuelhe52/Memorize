//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    struct Theme {
        let name: String
        let emojis: [String]
        let accentColor: Color
        let symbol: String
    }

    enum EmojiMemoryGameThemes: String, CaseIterable, Identifiable {
        private static let themes: [Theme] = [
            Theme(name: "Halloween", emojis: ["👻", "🎃", "💀", "🕷️", "👿", "🕸️","🐙", "🐍", "😵", "🙀", "🍬", "🧺"], accentColor: .purple, symbol: "ant"),
            Theme(name: "Animal", emojis: ["🐶", "🐭", "🐹", "🐰", "🦊", "🐻", "🐻‍❄️", "🐨", "🦁", "🐮", "🐷", "🐵"], accentColor: .pink, symbol: "pawprint"),
            Theme(name: "Digital", emojis: ["⌚️", "📱", "💻", "⌨️", "🖥️", "🖨️", "⏰", "🎙️", "📺", "📽️", "📻", "🧭"], accentColor: .blue, symbol: "pc"),
        ]
        
        var id: String { self.rawValue }
        case halloween
        case animal
        case digital
        
        var theme: Theme {
            switch self {
            case .halloween: return EmojiMemoryGame.EmojiMemoryGameThemes.themes[0]
            case .animal: return EmojiMemoryGameThemes.themes[1]
            case .digital: return EmojiMemoryGameThemes.themes[2]
            }
        }
        
        var accentColor: Color { return theme.accentColor }
        
        var emojis: [String] { return theme.emojis }
        
        var themeName: String { return theme.name }
        
        var symbol: String { return theme.symbol }
    }

    
    private static let defaultTheme = EmojiMemoryGameThemes.digital
    
    private static let defaultCardPairCount = 8
        
    private static func createMemoryGame(memoryGameTheme theme: EmojiMemoryGameThemes = defaultTheme) -> MemoryGame<String> {
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
    
    var currentTheme: EmojiMemoryGameThemes = defaultTheme
    
    var cards: Array<MemoryGame<String>.Card> {
        return memoryGame.cards
    }
    
    // MARK: - Intent
    
    func choose(_ card: MemoryGame<String>.Card) {
        memoryGame.chooseCard(card)
    }
    
    func startNewGame() {
        memoryGame.startNewGame()
    }
    
    func changeTheme(to theme: EmojiMemoryGameThemes) {
        let themeEmojis = theme.emojis
        currentColor = theme.accentColor
        currentTheme = theme
        
        memoryGame = EmojiMemoryGame.createMemoryGame(memoryGameTheme: theme)
        print("Theme changed: \(theme)")
    }
}
