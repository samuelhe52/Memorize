//
//  ContentView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

let halloweenTheme: [String] = ["👻", "🎃", "💀", "🕷️", "👿", "🕸️", "🐊", "🐙", "😱", "🍭", "🧙", "🙀"]
let animalTheme: [String] = ["🐶", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐯", "🦁", "🐮", "🐷"]
let digitalTheme: [String] = ["⌚️", "📱", "💻", "⌨️", "🖥️", "🖨️", "💿", "💾", "📷", "☎️", "📺", "📡"]

struct ContentView: View {
    @State var currentTheme: [String] = halloweenTheme
    @State var cardCount: Int = 5
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
                .foregroundStyle(.linearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            themeModifiers
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
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: currentTheme[index])
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
    
    var themeModifiers: some View {
        VStack {
            Text("Choose your theme here")
            HStack {
                Button("Halloween") {
                    currentTheme = halloweenTheme
                }
                Button("Animal") {
                    currentTheme = animalTheme
                }
                Button("Digital") {
                    currentTheme = digitalTheme
                }
            }
        }
    }
    
    func cardCountModifier(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > currentTheme.count)
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
            let base = RoundedRectangle(cornerRadius: 15)
            base.strokeBorder(lineWidth: 3)
            Text(content).font(.largeTitle)
            base.foregroundStyle(.orange)
                .opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
