//
//  CardView.swift
//  Memorize
//
//  Created by Samuel He on 2024/6/10.
//

import SwiftUI

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
