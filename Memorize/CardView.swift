//
//  CardView.swift
//  Memorize
//
//  Created by Samuel He on 2024/6/10.
//

import SwiftUI

struct CardView: View {
    typealias Card = MemoryGame<String>.Card

    let card: Card
    let baseColor: Color
    
    var body: some View {
        Pie(endAngle: .degrees(150))
            .opacity(0.4)
            .overlay(
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.1)
                    .multilineTextAlignment(.center)
                    .aspectRatio(4/3, contentMode: .fit)
            )
            .padding(5)
            .cardify(isFaceUp: card.isFaceUp)
            .foregroundStyle(.linearGradient(baseColor.brightnessGradient, startPoint: .bottomLeading, endPoint: .topTrailing))
            .opacity(card.isMatched ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: card.isMatched)
            .animation(.easeInOut(duration: 0.2), value: card.isFaceUp)
    }
}

#Preview {
    typealias Card = MemoryGame<String>.Card
    typealias CardID = MemoryGame<String>.CardID
    
    return VStack {
        HStack {
            CardView(card: Card(isFaceUp: true, content: "👻", id: CardID(description: "test1")), baseColor: .blue)
            CardView(card: Card(content: "X", id: CardID(description: "test1")), baseColor: .blue)
        }
        HStack {
            CardView(card: Card(isFaceUp: true, content: "This is a very long string and I hope it fits.", id: CardID(description: "test1")), baseColor: .blue)
            CardView(card: Card(isMatched: true, content: "X", id: CardID(description: "test1")), baseColor: .blue)
        }
    }
    .padding()
}
