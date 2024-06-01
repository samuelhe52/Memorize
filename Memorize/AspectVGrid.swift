//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Samuel He on 2024/6/2.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat = 1
    @ViewBuilder var contentBuilder: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                cardCount: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    contentBuilder(item)
                        .aspectRatio(3/4, contentMode: .fit)
                }
            }
        }
    }
    
    func gridItemWidthThatFits(
        cardCount: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        var columnCount: CGFloat = 1
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (CGFloat(cardCount) / CGFloat(columnCount)).rounded(.up)
            if CGFloat(rowCount * height) < size.height {
                return (size.width / CGFloat(columnCount)).rounded(.down)
            } else {
                columnCount += 1
            }
        } while columnCount < CGFloat(cardCount)
        return min(size.width / CGFloat(columnCount), size.height * aspectRatio).rounded(.down)
    }
}
