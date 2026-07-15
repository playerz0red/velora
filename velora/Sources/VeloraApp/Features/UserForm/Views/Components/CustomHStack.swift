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
        var currentX: CGFloat = .zero
        var currentY: CGFloat = .zero
        var maxItemHeight: CGFloat = .zero
        var maxWidth: CGFloat = .zero
        
        subviews.forEach { subview in
            let itemSize = subview.sizeThatFits(proposal)
            
            if currentX + itemSize.width >= horizontalLimit {
                currentY += maxItemHeight
                currentY += spacing
                currentX = itemSize.width + spacing
                maxItemHeight = itemSize.height
                return
            }
            
            currentX += itemSize.width
            currentX += spacing
            
            if itemSize.height > maxItemHeight {
                maxItemHeight = itemSize.height
            }
            
            if currentX > maxWidth {
                maxWidth = currentX
            }
            
            if currentX >= horizontalLimit {
                
                currentY += maxItemHeight
                currentY += spacing
                currentX = .zero
                maxItemHeight = .zero
            }
        }
        
        return CGSize(width: maxWidth, height: currentY + maxItemHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var maxItemHeight: CGFloat = .zero
        
        subviews.forEach { subview in
            let itemSize = subview.sizeThatFits(proposal)
            
            if currentX + itemSize.width >= horizontalLimit + bounds.minX {
                currentY += maxItemHeight
                currentY += spacing
                currentX = bounds.minX
                maxItemHeight = itemSize.height
                subview.place(at: CGPoint(x: currentX, y: currentY), anchor: UnitPoint.topLeading, proposal: proposal)
                currentX += itemSize.width + spacing
                return
            }
            
            subview.place(at: CGPoint(x: currentX, y: currentY), anchor: UnitPoint.topLeading, proposal: proposal)
            
            currentX += itemSize.width
            currentX += spacing
            
            if itemSize.height > maxItemHeight {
                maxItemHeight = itemSize.height
            }
            
            if currentX >= horizontalLimit + bounds.minX {
                currentY += maxItemHeight
                currentY += spacing
                currentX = bounds.minX
                maxItemHeight = .zero
            }
        }
    }
}
