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
        AspectVGrid(items: emojiMemoryGame.cards, aspectRatio: cardAspectRatio) { card in
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
                themeModifier(to: theme, symbol: theme.symbol)
            }
        }
        .padding(.trailing)
    }
    
    func themeModifier(to theme: EmojiMemoryGame.MemoryGameTheme, symbol: String) -> some View {
        return VStack {
            Button(action: {
                emojiMemoryGame.changeTheme(to: theme)
            }, label: {
                Image(systemName: symbol)
                    .font(.title2)
            })
            Text(theme.name)
                .font(.footnote)
        }
        .foregroundStyle(theme.accentColor)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let baseColor: Color
    
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
        .foregroundStyle(.linearGradient(stops: baseColor.brightnessGradient.stops, startPoint: .bottomLeading, endPoint: .topTrailing))
        .opacity(card.isMatched ? 0 : 1)
        .animation(.easeInOut(duration: 0.5), value: card.isMatched)
        .animation(.easeInOut(duration: 0.2), value: card.isFaceUp)
    }
}

extension Color {
    var brightnessGradient: Gradient {
        func getHSB(_ col: Color) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
            var hue: CGFloat = 0.0
            var saturation: CGFloat = 0.0
            var brightness: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            
            let uiColor = UIColor(col)
            uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            return (hue, saturation, brightness, alpha)
        }
        
        let baseHSB = getHSB(self)
        let lighter = Color(hue: baseHSB.0, saturation: baseHSB.1, brightness: baseHSB.2 - 0.4, opacity: baseHSB.3)
        let darker = Color(hue: baseHSB.0, saturation: baseHSB.1, brightness: baseHSB.2 + 0.4, opacity: baseHSB.3)
        return Gradient(colors: [lighter, self, darker])
    }
}

#Preview {
    MemoryGameView(emojiMemoryGame: EmojiMemoryGame())
}
