//
//  File.swift
//  Memorize
//
//  Created by Samuel He on 2024/6/10.
//

import SwiftUI
import CoreGraphics

/// A pie shape with a specified `startAngle` and `endAngle`.
struct Pie: Shape {
    var startAngle: Angle = .degrees(-90)
    var endAngle: Angle
    let clockwise: Bool = true
    // !!! "clockwise" refers to positive y axis to positive x axis.
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: !clockwise
        )
        p.addLine(to: center)
        return p
    }
}
