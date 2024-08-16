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
    
    private struct Constants {
        struct Card {
            static let aspectRatio: CGFloat = 3/4
        }
        
        struct Deal {
            static let duration: TimeInterval = 0.6
            static let delay: TimeInterval = 0.1
            static let deckWidth: CGFloat = 50
        }
        
        struct Theme {
            static let spacing: CGFloat = 30
            static let changeDuration: TimeInterval = 0.4
        }
        
        static let cardFlipDuration: TimeInterval = 0.4
    }
        
    var body: some View {
        VStack {
            Spacer(minLength: 15)
            if !emojiMemoryGame.isGameFinished {
                cards
                Spacer(minLength: 20)
            }
            HStack {
                score.padding(.horizontal)
                deck.padding(.horizontal)
            }
            Spacer(minLength: 20)
            barAtBottom
        }
        .padding()
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
        AspectVGrid(items: emojiMemoryGame.cards,
                    aspectRatio: Constants.Card.aspectRatio,
                    allRowsFilled: true) { card in
            if isDealt(card) {
                CardView(card: card,
                         baseColor: emojiMemoryGame.currentColor)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .padding(3)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(lastScoreChange.causedByCardID == card.id ? 100 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
    }
    
    @State private var dealtCardIDs = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealtCardIDs.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        emojiMemoryGame.cards.filter { !isDealt($0) }
    }
    
    private func cleanDealtCards() {
        dealtCardIDs.removeAll()
    }
    
    @Namespace private var dealingNameSpace
    
    var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card: card,
                         baseColor: emojiMemoryGame.currentColor)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
            }
            .frame(width: Constants.Deal.deckWidth,
                   height: Constants.Deal.deckWidth / Constants.Card.aspectRatio)
        }
        .onTapGesture { deal() }
    }
    
    private let dealAnimation: Animation = .spring(duration: Constants.Deal.duration)

    private func deal() {
        // deal the cards
        var delay: TimeInterval = 0
        for card in emojiMemoryGame.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealtCardIDs.insert(card.id)
            }
            delay += Constants.Deal.delay
        }
    }
        
    private func choose(_ card: Card) {
        withAnimation(.easeInOut(duration: Constants.cardFlipDuration)) {
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
            withAnimation(.spring(duration: Constants.Theme.changeDuration)) {
                emojiMemoryGame.startNewGame()
                cleanDealtCards()
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
        HStack(alignment: .lastTextBaseline, spacing: Constants.Theme.spacing) {
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
                withAnimation(.easeInOut(duration: Constants.Theme.changeDuration)) {
                    emojiMemoryGame.changeTheme(to: theme)
                    cleanDealtCards()
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
