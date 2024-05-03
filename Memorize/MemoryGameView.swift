//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

struct MemoryGameView: View {
    var emojiMemoryGame: EmojiMemoryGame = EmojiMemoryGame()
    
//    @State var currentTheme: [String] = EmojiMemoryGame.halloweenTheme.flatMap { [$0, $0] }.shuffled()
//    @State var currentColor: Color = .cyan
    
    var body: some View {
        VStack {
            title
            Spacer(minLength: 20)
            ScrollView {
                cards.foregroundStyle(.purple)
            }
            Button("Shuffle") {
                emojiMemoryGame.shuffle()
            }
//            themeModifiers
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
            ForEach(emojiMemoryGame.cards.indices, id: \.self) { index in
                CardView(emojiMemoryGame.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
        }
    }
//    
//    var themeModifiers: some View {
//        HStack(alignment: .lastTextBaseline, spacing: 35) {
//            themeModifier(to: "Animal", symbol: "pawprint")
//            themeModifier(to: "Halloween", symbol: "ant")
//            themeModifier(to: "Digital", symbol: "pc")
//        }
//    }
//    
//    func themeProcessor(_ theme: [String]) -> [String] {
//        return (theme + theme).shuffled()
//    }
//    
//    func themeModifier(to theme: String, symbol: String) -> some View {
//        let themeEmojis = themeProcessor(availableThemes[theme]?.1 ?? halloweenTheme)
//        let themeColor = availableThemes[theme]?.0 ?? .purple
//        return VStack {
//            Button(action: {
//                currentTheme = themeEmojis
//                currentColor = themeColor
//            }, label: {
//                Image(systemName: symbol)
//                    .font(.title2)
//            })
//            Text(theme)
//                .font(.footnote)
//        }
//        .foregroundStyle(themeColor)
//    }
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
                .aspectRatio(1, contentMode: .fit)
            base.opacity(card.isFaceUp ? 0 : 1)
        }
    }
}

#Preview {
    MemoryGameView()
}
