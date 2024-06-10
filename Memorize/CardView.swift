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
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15)
            base.strokeBorder(lineWidth: 3)
            Text(card.content)
                .font(.system(size: 200))
                .minimumScaleFactor(0.1)
                .multilineTextAlignment(.center)
                .aspectRatio(4/3, contentMode: .fit)
                .padding(5)
            base.opacity(card.isFaceUp ? 0 : 1)
        }
        .foregroundStyle(.linearGradient(stops: baseColor.brightnessGradient.stops, startPoint: .bottomLeading, endPoint: .topTrailing))
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
            CardView(card: Card(isFaceUp: true, content: "X", id: CardID(description: "test1")), baseColor: .blue)
            CardView(card: Card(content: "X", id: CardID(description: "test1")), baseColor: .blue)
        }
        HStack {
            CardView(card: Card(isFaceUp: true, content: "This is a very long string and I hope it fits.", id: CardID(description: "test1")), baseColor: .blue)
            CardView(card: Card(isMatched: true, content: "X", id: CardID(description: "test1")), baseColor: .blue)
        }
    }
    .padding()
}
