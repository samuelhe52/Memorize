//
//  Cardify.swift
//  Memorize
//
//  Created by Samuel He on 2024/6/10.
//

import SwiftUI

/// Makes any View looks like a "Card".
struct Cardify: ViewModifier {
    let isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15)
            base.strokeBorder(lineWidth: 3)
                .overlay(content)
            base.opacity(isFaceUp ? 0 : 1)
        }
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View { self.modifier(Cardify(isFaceUp: isFaceUp)) }
}
