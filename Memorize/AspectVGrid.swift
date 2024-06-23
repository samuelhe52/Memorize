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
    var allRowsFilled: Bool = false
    @ViewBuilder var contentBuilder: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemWidth = gridItemWidthThatFits(
                itemCount: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio,
                allRowsFilled: allRowsFilled
            )
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemWidth), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    contentBuilder(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    /// Finds the appropriate grid item width that best fits in a given size
    /// and returns it.
    func gridItemWidthThatFits(
        itemCount: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat,
        allRowsFilled: Bool = false
    ) -> CGFloat {
        var columnCount: CGFloat = 1
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (CGFloat(itemCount) / CGFloat(columnCount)).rounded(.up)
            
            if allRowsFilled {
                if (CGFloat(rowCount * height) < size.height) && (itemCount % Int(columnCount) == 0) {
                    return (size.width / CGFloat(columnCount)).rounded(.down)
                } else {
                    columnCount += 1
                }
            } else {
                if CGFloat(rowCount * height) < size.height {
                    return (size.width / CGFloat(columnCount)).rounded(.down)
                } else {
                    columnCount += 1
                }
            }
        } while columnCount < CGFloat(itemCount)
        return min(size.width / CGFloat(columnCount), size.height * aspectRatio).rounded(.down)
    }
}
