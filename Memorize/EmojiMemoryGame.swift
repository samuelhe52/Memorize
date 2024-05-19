//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    enum EmojiMemoryGameTheme: CaseIterable {
        private static let halloweenThemeEmojis: [String] = ["👻", "🎃", "💀", "🕷️", "👿", "🕸️","🐙", "🐍", "😵", "🙀", "🍬", "🧺"]
        private static let animalThemeEmojis: [String] = ["🐶", "🐭", "🐹", "🐰", "🦊", "🐻", "🐻‍❄️", "🐨", "🦁", "🐮", "🐷", "🐵"]
        private static let digitalThemeEmojis: [String] = ["⌚️", "📱", "💻", "⌨️", "🖥️", "🖨️", "⏰", "🎙️", "📺", "📽️", "📻", "🧭"]
        
        case halloween
        case animal
        case digital
        
        var accentColor: Color {
            switch self {
            case .animal: return .pink
            case .digital: return .blue
            case .halloween: return .purple
            }
        }
        
        var emojis: [String] {
            switch self {
            case .animal: return EmojiMemoryGameTheme.animalThemeEmojis
            case .digital: return EmojiMemoryGameTheme.digitalThemeEmojis
            case .halloween: return EmojiMemoryGameTheme.halloweenThemeEmojis
            }
        }
        
        var themeName: String {
            switch self {
            case .animal: return "Animal"
            case .digital: return "Digital"
            case .halloween: return "Halloween"
            }
        }
    }
    
    private static let defaultTheme = EmojiMemoryGameTheme.halloween
        
    private static func makeMemoryGame(memoryGameTheme theme: EmojiMemoryGameTheme = defaultTheme) -> MemoryGame<String> {
        let themeEmojis = theme.emojis
        
        return MemoryGame(numberOfPairsOfCards: themeEmojis.count) { pairIndex in
            if themeEmojis.indices.contains(pairIndex) {
                return themeEmojis[pairIndex]
            } else {
                return "❌"
            }
        }
    }
    
    @Published private var memoryGame = makeMemoryGame()
    
    var currentColor: Color = defaultTheme.accentColor
    
    var cards: Array<MemoryGame<String>.Card> {
        return memoryGame.cards
    }
    
    // MARK: - Intent
    
    func choose(_ card: MemoryGame<String>.Card) {
        memoryGame.chooseCard(card)
    }
    
    func shuffleCards() {
        memoryGame.shuffleCards()
    }
    
    func changeTheme(to theme: EmojiMemoryGameTheme) {
        let themeEmojis = theme.emojis
        
        func makeCardContent(pairIndex: Int) -> String {
            if themeEmojis.indices.contains(pairIndex) {
                return themeEmojis[pairIndex]
            } else {
                return "❌"
            }
        }
        
        currentColor = theme.accentColor
        memoryGame.changeTheme(numberOfPairsOfCards: themeEmojis.count, cardContentFactory: makeCardContent)
        
        print("Theme changed: \(theme)")
    }
}
