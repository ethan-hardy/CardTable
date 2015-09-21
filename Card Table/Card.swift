//
//  Card.swift
//  Swift Stuff
//
//  Created by Ethan Hardy on 2015-07-15.
//  Copyright (c) 2015 Ethan Hardy. All rights reserved.
//

import UIKit

class Card: UIImageView {

    var lastTouch : CGPoint!
    var cardNumber : Int! {
        didSet {
            if (isFaceUp) {
                self.image = UIImage(named: "\(cardNumber)")!
            }
        }
    }
    var isFaceUp : Bool
    var isTopCardOfDeck : Bool
    var touchIsHolding : Bool
    var ownerDeck : Deck!
    override var image : UIImage? {
        didSet {
            if let iSize = image?.size {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, iSize.width, iSize.height)
            }
        }
    }
    
    init(cardNum: Int, faceUp: Bool, deck: Deck?) {
        var img : UIImage
        cardNumber = cardNum
        isFaceUp = faceUp
        isTopCardOfDeck = true
        ownerDeck = deck
        touchIsHolding = false
        if (faceUp) {
            img = UIImage(named: "\(cardNumber)")!
        }
        else if (ownerDeck != nil) {
            img = UIImage(named: "backv_deck")!
        }
        else {
            img = UIImage(named: "backv")!
        }
        super.init(image: img)
    }

    required init?(coder aDecoder: NSCoder) {
        isFaceUp = false
        isTopCardOfDeck = true
        touchIsHolding = false
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchIsHolding = true
        let obj : NSObject = touches.first!
        let touch : UITouch = obj as! UITouch
        lastTouch = touch.locationInView(self.superview)
        self.ownerDeck.board!.touchIsOnTable = false
        if (isTopCardOfDeck) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(300000000 /* 0.3 seconds */)), dispatch_get_main_queue(), { () -> Void in
                if (self.touchIsHolding) {
                    self.ownerDeck.isMoveEnabled = true
                    let center = self.center
                    UIView.animateWithDuration(NSTimeInterval(0.2), animations: { () -> Void in
                        self.frame.size = CGSizeMake(self.frame.width * 1.15, self.frame.height * 1.15)
                        self.center = center
                        if (self.ownerDeck.board!.dropDownOptionMenu.selectedDeck != nil && self.ownerDeck.board!.dropDownOptionMenu.selectedDeck!.isEqual(self.ownerDeck)) {
                            self.ownerDeck.board!.selectedDeckBorder.setBorderSizedFrame(self.frame.origin, isZoomSized: true)
                        }
                        self.image = UIImage(named: "backv_deck_dark")
                    })
                    self.superview?.bringSubviewToFront(self)
                }
            });
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (isTopCardOfDeck && !ownerDeck.isMoveEnabled) {
            self.ownerDeck.board!.drawCardFromDeck(ownerDeck)
            isTopCardOfDeck = false
        }
        touchIsHolding = false
        self.superview!.bringSubviewToFront(self)
        
        let obj : NSObject = touches.first!
        let touch : UITouch = obj as! UITouch
        var currentTouch : CGPoint = touch.locationInView(self.superview)
        let deltaTouch : CGSize = CGSize(width: currentTouch.x - lastTouch.x, height: currentTouch.y - lastTouch.y)
        
        let newFrame : CGRect = CGRectMake(self.frame.origin.x + deltaTouch.width, self.frame.origin.y + deltaTouch.height, self.frame.width, self.frame.height)
        var finalOrigin = self.frame.origin
        let screenRect : CGRect = CGRectMake(0, 0, self.superview!.frame.width, self.superview!.frame.height / 2)
        if ((self.ownerDeck.board!.isViewingTable && screenRect.contains(newFrame)) || (!self.ownerDeck.board!.isViewingTable && screenRect.contains(newFrame.offsetBy(dx: 0, dy: -self.ownerDeck.board!.frame.height / 2)))) {
            //card has not hit a screen border
            finalOrigin = CGPoint(x: self.frame.origin.x + deltaTouch.width, y: self.frame.origin.y + deltaTouch.height)
            self.frame.origin = finalOrigin
        }
        else if (((newFrame.maxY >= self.ownerDeck.board!.frame.height / 2 && self.ownerDeck.board!.isViewingTable) || (newFrame.minY <= self.ownerDeck.board!.frame.height / 2 && !self.ownerDeck.board!.isViewingTable)) && !isTopCardOfDeck) {
            //card has hit the top of the screen while viewing hand or the bottom while viewing table; should prompt view change
            self.ownerDeck.board!.changeTableView(self)
            currentTouch.y = currentTouch.y + self.ownerDeck.board!.frame.height / 2
        }
        else {
            //the card will hit the side, but not so as to trigger a view switch
           /* var ratio : CGFloat
            if (newFrame.origin.x < 0) {
                ratio = self.frame.origin.x / deltaTouch.width
            }
            else if (newFrame.maxX > self.superview!.frame.width) {
                ratio = (self.superview!.frame.width - self.frame.maxX) / deltaTouch.width
            }
            else if (newFrame.origin.y < 0) {
                ratio = self.frame.origin.y / deltaTouch.height
            }
            else {
                ratio = (self.superview!.frame.height - self.frame.maxY) / deltaTouch.height
            }
            if (ratio > 0 && ratio <= 1) {
                finalOrigin = CGPoint(x: self.frame.origin.x + deltaTouch.width * ratio, y: self.frame.origin.y + deltaTouch.height * ratio)
            }
            self.frame.origin = finalOrigin*/
        }
        lastTouch = currentTouch
        if (ownerDeck.isMoveEnabled) {
            ownerDeck.origin = finalOrigin
        }
        
        if (self.ownerDeck.board!.selectedCardBorder.ownerCard != nil && self.ownerDeck.board!.selectedCardBorder.ownerCard!.isEqual(self)) { //if this is the selected card
            self.ownerDeck.board!.selectedCardBorder.setBorderPositionedOrigin(self.frame.origin)
        }
        else if (self.ownerDeck.board!.selectedDeckBorder.ownerDeck != nil && self.ownerDeck.board!.selectedDeckBorder.ownerDeck!.isEqual(self.ownerDeck) && self.isTopCardOfDeck) { //if this is the top card of the selected deck
            self.ownerDeck.board!.selectedDeckBorder.setBorderPositionedOrigin(self.frame.origin)
        }
    }
    
    func flip() {
        if (isFaceUp) {
            isFaceUp = false
            self.image = UIImage(named: "backv")
        }
        else {
            isFaceUp = true
            self.image = UIImage(named: "\(cardNumber)")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var zoomedOut : Bool = false
        if (ownerDeck.isMoveEnabled && self.isTopCardOfDeck) {
            zoomedOut = true
            ownerDeck.isMoveEnabled = false
            let center = self.center
            UIView.animateWithDuration(NSTimeInterval(0.2), animations: { () -> Void in
                self.frame.size = CGSizeMake(self.frame.width / 1.15, self.frame.height / 1.15)
                self.center = center
                if (self.ownerDeck.board!.dropDownOptionMenu.selectedDeck != nil && self.ownerDeck.board!.dropDownOptionMenu.selectedDeck!.isEqual(self.ownerDeck)) {
                    self.ownerDeck.board!.selectedDeckBorder.setBorderSizedFrame(self.frame.origin, isZoomSized: false)
                }
                self.image = UIImage(named: "backv_deck")
            })
        }
        if (touchIsHolding && !zoomedOut) {
            self.ownerDeck.board!.selectCardOrDeck(self)
            touchIsHolding = false
        }
    }
    
    
    override func removeFromSuperview() {
        if (self.ownerDeck.board!.dropDownOptionMenu.selectedCard != nil && self.ownerDeck.board!.dropDownOptionMenu.selectedCard!.isEqual(self)) {
            self.ownerDeck.board?.deselectCard(true, orDeck: false)
        }
        super.removeFromSuperview()
    }
    
    
   /* func drawBorder() {
        UIGraphicsBeginImageContext(self.frame.size)
        var context : CGContextRef = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        CGContextAddRect(context, CGRectMake(0, 0, self.frame.width - 2, self.frame.height - 2))
        CGContextSetLineWidth(context, 4)
        CGContextStrokePath(context)
        UIGraphicsEndImageContext()
    }*/
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        var context : CGContextRef = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        CGContextAddRect(context, CGRectMake(0, 0, self.frame.width - 2, self.frame.height - 2))
        CGContextSetLineWidth(context, 4)
        CGContextStrokePath(context)
    }
    */

}
