//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Samuel He on 2024/4/27.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            MemoryGameView(emojiMemoryGame: game)
        }
    }
}
