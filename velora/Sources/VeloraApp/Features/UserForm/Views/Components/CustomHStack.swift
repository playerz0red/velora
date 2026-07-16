//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 14.07.26.
//

import Foundation
import SwiftUI

struct CustomHStack: Layout {
    
    private let horizontalLimit: CGFloat
    private let spacing: CGFloat
    
    init(horizontalLimit: CGFloat, spacing: CGFloat) {
        self.horizontalLimit = horizontalLimit
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        calculateLayout(for: subviews, proposal: proposal, origin: .zero).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let layout = calculateLayout(for: subviews, proposal: proposal, origin: bounds.origin)
        
        for (subview, frame) in zip(subviews, layout.frames) {
            subview.place(
                at: frame.origin,
                anchor: UnitPoint.topLeading,
                proposal: ProposedViewSize(frame.size)
            )
        }
    }
    
    private func calculateLayout(
        for subviews: Subviews,
        proposal: ProposedViewSize,
        origin: CGPoint
    ) -> (size: CGSize, frames: [CGRect]) {
        
        var currentX: CGFloat = origin.x
        var currentY: CGFloat = origin.y
        var maxItemHeight: CGFloat = .zero
        var maxWidth: CGFloat = .zero
        var frames: [CGRect] = []
        
        for subview in subviews {
            let itemSize = subview.sizeThatFits(proposal)
            
            if currentX + itemSize.width > origin.x + horizontalLimit && currentX > origin.x {
                maxWidth = max(maxWidth, currentX - origin.x - spacing)
                
                currentY += maxItemHeight + spacing
                currentX = origin.x
                maxItemHeight = .zero
            }
            
            let frame = CGRect(origin: CGPoint(x: currentX, y: currentY), size: itemSize)
            frames.append(frame)
            
            currentX += itemSize.width + spacing
            maxItemHeight = max(maxItemHeight, itemSize.height)
        }
        
        maxWidth = max(maxWidth, currentX > origin.x ? currentX - origin.x - spacing : .zero)
        let totalHeight = (currentY + maxItemHeight) - origin.y
        
        return (CGSize(width: maxWidth, height: totalHeight), frames)
    }
}
