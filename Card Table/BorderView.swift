//
//  BorderView.swift
//  Swift Stuff
//
//  Created by Ethan Hardy on 2015-09-16.
//  Copyright (c) 2015 Ethan Hardy. All rights reserved.
//

import UIKit
import CoreGraphics

class BorderView: UIView {
    
    var ownerCard : Card?
    var ownerDeck : Deck?
    let normalCardSize : CGSize = CGSize(width: 70, height: 99)
    let zoomCardSize : CGSize = CGSize(width: 70 * 1.15, height: 99 * 1.15)

    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = false
        opaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        userInteractionEnabled = false
        opaque = false
    }
    
    private func setBorderSizedFrame(frame: CGRect) {
        self.frame = CGRectMake(frame.origin.x - 2, frame.origin.y - 2, frame.width + 4, frame.height + 4)
        setNeedsDisplay()
    }
    
    func setBorderSizedFrame(origin: CGPoint, isZoomSized: Bool) {
        self.setBorderSizedFrame(CGRectMake(origin.x, origin.y, isZoomSized ? zoomCardSize.width : normalCardSize.width, isZoomSized ? zoomCardSize.height : normalCardSize.height))
    }
    
    func setBorderPositionedOrigin(origin: CGPoint) {
        self.frame.origin = CGPointMake(origin.x - 2, origin.y - 2)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context : CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextBeginPath(context)
        let path : CGMutablePathRef = CGPathCreateMutable()
        CGPathAddRoundedRect(path, nil, CGRectMake(2, 2, self.frame.width-4, self.frame.height-4), 4, 4)
        CGContextAddPath(context, path)
        CGContextSetLineWidth(context, 3)
        if (self.ownerCard != nil) {
            CGContextSetRGBStrokeColor(context, 0, 0, 0.36, 1.0)
        }
        else {
            CGContextSetRGBStrokeColor(context, 1/255, 66 / 255, 0, 1.0)
        }
        CGContextStrokePath(context)
    }
}
