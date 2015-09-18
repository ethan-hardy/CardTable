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

    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = false
        opaque = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        userInteractionEnabled = false
        opaque = false
    }
    
    func setBorderSizedFrame(frame: CGRect) {
        self.frame = CGRectMake(frame.origin.x - 2, frame.origin.y - 2, frame.width + 4, frame.height + 4)
        setNeedsDisplay()
    }
    
    func setBorderPositionedOrigin(origin: CGPoint) {
        self.frame.origin = CGPointMake(origin.x - 2, origin.y - 2)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        var context : CGContextRef = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        var path : CGMutablePathRef = CGPathCreateMutable()
        CGPathAddRoundedRect(path, nil, CGRectMake(2, 2, self.frame.width-4, self.frame.height-4), 4, 4)
        CGContextAddPath(context, path)
        CGContextSetLineWidth(context, 3)
        CGContextSetRGBStrokeColor(context, 0, 0, 0.36, 1.0)
        CGContextStrokePath(context)
    }
}
