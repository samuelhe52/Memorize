//
//  ContentView.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

let halloweenTheme: [String] = ["👻", "🎃", "💀", "🕷️", "👿", "🕸️"]
let animalTheme: [String] = ["🐶", "🐭", "🐹", "🐰", "🦊", "🐻"]
let digitalTheme: [String] = ["⌚️", "📱", "💻", "⌨️", "🖥️", "🖨️"]
let availableThemes: [String: (Color, [String])] = ["Halloween": (.purple, halloweenTheme), "Animal": (.pink, animalTheme), "Digital": (.blue, digitalTheme)]

struct ContentView: View {
    @State var currentTheme: [String] = halloweenTheme.flatMap { [$0, $0] }.shuffled()
    @State var currentColor: Color = .cyan
    
    var body: some View {
        VStack {
            title
            Spacer(minLength: 20)
            ScrollView {
                cards.foregroundStyle(currentColor)
            }
            themeModifiers
        }
        .padding()
    }
    
    var title: some View {
        Text("Memorize!")
            .font(.largeTitle)
            .foregroundStyle(.linearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
            ForEach(currentTheme.indices, id: \.self) { index in
                CardView(content: currentTheme[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
    }
    
    var themeModifiers: some View {
        HStack(alignment: .lastTextBaseline, spacing: 35) {
            themeModifier(to: "Animal", symbol: "dog")
            themeModifier(to: "Halloween", symbol: "ant")
            themeModifier(to: "Digital", symbol: "pc")
        }
    }
    
    func themeProcessor(_ theme: [String]) -> [String] {
        return (theme + theme).shuffled()
    }
    
    func themeModifier(to theme: String, symbol: String) -> some View {
        let themeEmojis = themeProcessor(availableThemes[theme]?.1 ?? halloweenTheme)
        let themeColor = availableThemes[theme]?.0 ?? .purple
        return VStack {
            Button(action: {
                currentTheme = themeEmojis
                currentColor = themeColor
            }, label: {
                Image(systemName: symbol)
                    .font(.title2)
            })
            Text(theme)
                .font(.footnote)
        }
        .foregroundStyle(themeColor)
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = false // Make isFaceUp mutable.
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15)
            base.strokeBorder(lineWidth: 3)
            Text(content).font(.largeTitle)
            base.opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
