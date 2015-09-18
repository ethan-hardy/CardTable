//
//  DropDownOptionMenu.swift
//  Swift Stuff
//
//  Created by Ethan Hardy on 2015-09-17.
//  Copyright (c) 2015 Ethan Hardy. All rights reserved.
//

import UIKit


class DropDownOptionMenu: UIView {
    var isDroppedDown : Bool {
        didSet {
            if (self.isDroppedDown && self.frame.origin.y < 0) {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.frame.origin.y += self.frame.height * 2
                })
            }
            else if (!self.isDroppedDown && self.frame.origin.y >= 0) {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.frame.origin.y -= self.frame.height * 2
                })
            }
        }
    }
    
   /* func setupGraphics() {
        let cardLabel = UILabel(frame: <#CGRect#>)
    }
    */
    override init(frame: CGRect) {
        isDroppedDown = false
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1/255, green: 16/255, blue: 65/255, alpha: 0.55)
    }

    required init(coder aDecoder: NSCoder) {
        isDroppedDown = false
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 0.0, green: 0.145, blue: 0.309, alpha: 0.55)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        var context : CGContextRef = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(context, self.frame.width / 2, 10)
        CGContextAddLineToPoint(context, self.frame.width / 2, self.frame.height - 10)
        CGContextStrokePath(context)
    }

}
