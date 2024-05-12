//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    // Never use a default value, always pass in the ViewModel into View, for if it were given a default value, then the ViewModel could no longer be shared among other Views, which is contrary to our original intention.
        
    var body: some View {
        VStack {
            title
            Spacer(minLength: 20)
            ScrollView {
                cards
                    .foregroundStyle(emojiMemoryGame.currentColor)
                    .animation(.default, value: emojiMemoryGame.cards)
            }
            HStack(alignment: .lastTextBaseline) {
                themeModifiers
                Divider().frame(height: 40)
                shuffler
            }
        }
        .padding()
    }
    
    var title: some View {
        Text("Memorize!")
            .font(.largeTitle)
            .foregroundStyle(.linearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0) {
            ForEach(emojiMemoryGame.cards) { card in
                VStack(spacing: 0) {
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                    Text(card.id)
                }
            }
        }
    }
    
    var shuffler: some View {
        Button(action: {
            emojiMemoryGame.shuffleCards()
        }, label: {
            VStack {
                Image(systemName: "square.3.stack.3d.middle.fill")
                    .font(.title2)
                Text("Shuffle")
                    .font(.footnote)
            }
        })
        .foregroundStyle(emojiMemoryGame.currentColor)
        .padding(.leading)
    }
    
    var themeModifiers: some View {
        HStack(alignment: .lastTextBaseline, spacing: 35) {
            themeModifier(to: "Animal", symbol: "pawprint")
            themeModifier(to: "Halloween", symbol: "ant")
            themeModifier(to: "Digital", symbol: "pc")
        }
        .padding(.trailing)
    }
    
    func themeModifier(to theme: String, symbol: String) -> some View {
        return VStack {
            Button(action: {
                emojiMemoryGame.changeTheme(to: theme)
            }, label: {
                Image(systemName: symbol)
                    .font(.title2)
            })
            Text(theme)
                .font(.footnote)
        }
        .foregroundStyle(EmojiMemoryGame.availableThemes[theme]?.0 ?? .purple)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15)
            base.strokeBorder(lineWidth: 3)
            Text(card.content)
                .font(.system(size: 200))
                .minimumScaleFactor(0.01)
                .aspectRatio(4/3, contentMode: .fit)
            base.opacity(card.isFaceUp ? 0 : 1)
        }
    }
}

#Preview {
    MemoryGameView(emojiMemoryGame: EmojiMemoryGame())
}
