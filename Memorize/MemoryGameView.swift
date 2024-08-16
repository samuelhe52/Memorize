//
//  MemoryGameView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

struct MemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
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
        Text("Score: \(emojiMemoryGame.score)")
            .foregroundStyle(emojiMemoryGame.currentColor)
            .font(emojiMemoryGame.isGameFinished ? .largeTitle : .title3)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .scale(1.2)
                    .fill(Color(UIColor.systemGray5))
            )
    }
    
    var cards: some View {
        AspectVGrid(items: emojiMemoryGame.cards, aspectRatio: cardAspectRatio, allRowsFilled: true) { card in
            CardView(card: card, baseColor: emojiMemoryGame.currentColor)
                .padding(3)
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .zIndex(lastScoreChange.causedByCardID == card.id ? 100 : 0)
                .onTapGesture {
                    choose(card)
                }
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation(.easeInOut(duration: 0.4)) {
            let scoreBeforeChoosing = emojiMemoryGame.score
            emojiMemoryGame.choose(card)
            let scoreChange = emojiMemoryGame.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, card.id)
        }
    }
    
    var barAtBottom: some View {
        HStack(alignment: .lastTextBaseline) {
            themeModifiers
            Divider().frame(height: 40)
            newGame
                .padding(.leading)
        }
        .background(RoundedRectangle(cornerRadius: 13).scale(1.2).fill(Color(UIColor.systemGray6)))
    }
    
    var newGame: some View {
        Button(action: {
            withAnimation(.spring(duration: 0.4)) {
                emojiMemoryGame.startNewGame()
            }
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
    private func makeThemeModifier(
        to theme: EmojiMemoryGame.MemoryGameTheme,
        systemSymbol: String) -> some View {
        return VStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    emojiMemoryGame.changeTheme(to: theme)
                }
            }, label: {
                Image(systemName: systemSymbol)
                    .font(.title2)
            })
            Text(theme.name)
                .font(.footnote)
        }
        .foregroundStyle(theme.accentColor)
    }
    
    @State private var lastScoreChange = (0, causedByCardID: Card.ID(description: ""))
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, causedByCardID: id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

#Preview {
    MemoryGameView(emojiMemoryGame: EmojiMemoryGame())
}
