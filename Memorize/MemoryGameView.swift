//
//  MemoryGameView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    private let cardAspectRatio: CGFloat = 3/4
        
    var body: some View {
        VStack {
            title
            Spacer(minLength: 15)
            if !emojiMemoryGame.isGameFinished {
                cards
                Spacer(minLength: 20)
            }
            #if DEBUG
            Button(action: { toggleFinishedStatus() }, label: {
                Text("Debug: on and off screen")
            })
            #endif
            score
            Spacer(minLength: 20)
            barAtBottom
        }
        .padding()
    }
    
    var title: some View {
        Text("Memorize!")
            .font(.largeTitle)
            .foregroundStyle(.linearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    var score: some View {
        Text("Score: \(emojiMemoryGame.getScore())")
            .foregroundStyle(emojiMemoryGame.currentColor)
            .font(emojiMemoryGame.isGameFinished ? .largeTitle : .title3)
            .background(RoundedRectangle(cornerRadius: 8).scale(1.2).fill(Color(UIColor.systemGray5)))
            .animation(.bouncy, value: emojiMemoryGame.isGameFinished)
    }
    
    var cards: some View {
        AspectVGrid(items: emojiMemoryGame.cards, aspectRatio: cardAspectRatio, allRowsFilled: true) { card in
            CardView(card: card, baseColor: emojiMemoryGame.currentColor)
                .padding(3)
                .onTapGesture {
                    emojiMemoryGame.choose(card)
                }
        }
        .animation(.spring(duration: 0.4), value: emojiMemoryGame.cards)
    }
    
    var barAtBottom: some View {
        HStack(alignment: .lastTextBaseline) {
            themeModifiers
            Divider().frame(height: 40)
            newGame
                .animation(.default, value: emojiMemoryGame.currentColor)
                .padding(.leading)
        }
        .background(RoundedRectangle(cornerRadius: 13).scale(1.2).fill(Color(UIColor.systemGray6)))
    }
    
    var newGame: some View {
        Button(action: {
            emojiMemoryGame.startNewGame()
        }, label: {
            VStack {
                Image(systemName: "plus.circle")
                    .font(.title2)
                Text("New Game")
                    .font(.footnote)
            }
        })
    }
    
    var themeModifiers: some View {
        HStack(alignment: .lastTextBaseline, spacing: 30) {
            ForEach(EmojiMemoryGame.EmojiMemoryGameThemes.allCases) { theme in
                makeThemeModifier(to: theme, systemSymbol: theme.symbol)
            }
        }
        .padding(.trailing)
    }
    
    /// Creates a theme modifier view and returns it.
    /// - parameter theme: the modifier's linked theme.
    /// - parameter systemSymbol: the symbol to display for the modifier.
    func makeThemeModifier(
        to theme: EmojiMemoryGame.MemoryGameTheme,
        systemSymbol: String) -> some View {
        return VStack {
            Button(action: {
                emojiMemoryGame.changeTheme(to: theme)
            }, label: {
                Image(systemName: systemSymbol)
                    .font(.title2)
            })
            Text(theme.name)
                .font(.footnote)
        }
        .foregroundStyle(theme.accentColor)
    }
}

// MARK: - Only for debugging and testing
extension MemoryGameView {
    func toggleFinishedStatus() {
        emojiMemoryGame.finishedForDebugging.toggle()
    }
}

#Preview {
    MemoryGameView(emojiMemoryGame: EmojiMemoryGame())
}
