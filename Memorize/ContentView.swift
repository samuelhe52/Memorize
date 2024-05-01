//
//  ContentView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

struct ContentView: View {
    let emojis: [String] = ["👻", "🎃", "💀", "🕷️", "👿", "🕸️", "🪼", "🐙", "😱", "🍭", "🧙", "🙀"]

    @State var cardCount: Int = 4
    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<cardCount, id: \.self) { _ in
                    CardView(content: emojis.randomElement()!)
                }
            }        
            .foregroundStyle(.orange)
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 120, height: 30, alignment: .center)
                    Button("Add Card") {
                        if cardCount <= 9 {
                            cardCount += 1
                        }
                    }
                    .foregroundStyle(.white)
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 120, height: 30, alignment: .center)
                    Button("Remove Card") {
                        if cardCount >= 2 {
                            cardCount -= 1
                        }
                    }
                    .foregroundStyle(.white)
                }
            }
            .foregroundStyle(.cyan)
        }
        .padding()
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
