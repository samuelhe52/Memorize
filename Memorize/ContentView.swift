//
//  ContentView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

struct ContentView: View {
    let emojis: [String] = ["👻", "🎃", "💀", "🕷️", "👿", "🕸️", "🪼", "🐙", "😱", "🍭", "🧙", "🙀"]

    @State var cardCount: Int = 5
    
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Spacer()
            cardCountModifiers
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
            ForEach(0..<cardCount, id: \.self) { _ in
                CardView(content: emojis.randomElement()!)
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundStyle(.orange)
    }
    
    var cardCountModifiers: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
    }
    
    func cardCountModifier(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > 32)
    }
    
    var cardRemover: some View {
        cardCountModifier(by: -1, symbol: "rectangle.stack.badge.minus")
    }
    
    var cardAdder: some View {
        cardCountModifier(by: 1, symbol: "rectangle.stack.badge.plus")
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true // Make isFaceUp mutable.
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 13)
            Group {
                base.foregroundStyle(.white)
                base.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
