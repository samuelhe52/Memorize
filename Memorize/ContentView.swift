//
//  ContentView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

struct ContentView: View {
    let emojis: [String] = ["👻", "🎃", "💀", "🕷️", "👿", "🕸️", "🪼", "🐙", "😱", "🍭", "🧙", "🙀"]

    @State var cardCount = 4
    
    var body: some View {
        VStack {
            ForEach(0..<5) { _ in
                HStack {
                    ForEach(0..<4) { _ in
                        CardView(content: emojis.randomElement()!)
                    }
                }
                .padding()
            }
        }
        .padding()
        .foregroundStyle(.orange)
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true // Make isFaceUp mutable.
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 25)
            if isFaceUp {
                base.foregroundStyle(.white)
                base.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                base
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
