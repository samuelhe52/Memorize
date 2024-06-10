//
//  BrightnessGradient.swift
//  Memorize
//
//  Created by Samuel He on 2024/6/10.
//

import SwiftUI

extension Color {
    var brightnessGradient: Gradient {
        func getHSB(_ col: Color) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
            var hue: CGFloat = 0.0
            var saturation: CGFloat = 0.0
            var brightness: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            
            let uiColor = UIColor(col)
            uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            return (hue, saturation, brightness, alpha)
        }
        
        let baseHSB = getHSB(self)
        let lighter = Color(hue: baseHSB.0, saturation: baseHSB.1, brightness: baseHSB.2 - 0.4, opacity: baseHSB.3)
        let darker = Color(hue: baseHSB.0, saturation: baseHSB.1, brightness: baseHSB.2 + 0.4, opacity: baseHSB.3)
        return Gradient(colors: [lighter, self, darker])
    }
}
