//
//  Cardify.swift
//  Memorize
//
//  Created by Samuel He on 2024/6/10.
//

import SwiftUI

/// Makes any View looks like a "Card".
struct Cardify: ViewModifier, Animatable {
    init(isFaceUp: Bool) {
        self.rotation = isFaceUp ? .zero : .degrees(180)
    }
    
    var isFaceUp: Bool { rotation < .degrees(90) }
    
    var rotation: Angle
    var animatableData: Double {
        get { rotation.degrees }
        set { rotation = .degrees(newValue) }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15)
            base.strokeBorder(lineWidth: 3)
                .background(base.fill(.background))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(
            rotation,
            axis: (x: 0, y: 1, z: 0)
        )
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View { self.modifier(Cardify(isFaceUp: isFaceUp)) }
}
