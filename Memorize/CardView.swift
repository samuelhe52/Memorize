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
    let backgroundGradient: Gradient
    
    init(card: Card, baseColor: Color) {
        self.card = card
        self.baseColor = baseColor
        self.backgroundGradient = baseColor.brightnessGradient
    }
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/10)) { context in
            if !card.isMatched {
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360 - 90))
                    .opacity(0.4)
                    .overlay(cardContent)
                    .padding(5)
                    .cardify(isFaceUp: card.isFaceUp)
                    .foregroundStyle(.linearGradient(backgroundGradient, startPoint: .topTrailing, endPoint: .bottomLeading))
                    .transition(.scale)
            } else {
                Color.clear
            }
        }
    }
    
    var cardContent: some View {
        Text(card.content)
            .font(.system(size: 200))
            .minimumScaleFactor(0.1)
            .multilineTextAlignment(.center)
            .aspectRatio(4/3, contentMode: .fit)
    }
}

#Preview {
    typealias Card = MemoryGame<String>.Card
    typealias CardID = Card.ID
    
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
