//
//  DropDownOptionMenu.swift
//  Swift Stuff
//
//  Created by Ethan Hardy on 2015-09-17.
//  Copyright (c) 2015 Ethan Hardy. All rights reserved.
//

import UIKit


class DropDownOptionMenu: UIView {
    let textColor : UIColor = UIColor(red: 230.0/255.0, green: 242.0/255.0, blue: 213.0/255.0, alpha: 0.7)
    let disabledTextColor : UIColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 0.7)
    let labelTextColor : UIColor = UIColor(red: 187/255, green: 220/255, blue: 232/255, alpha: 0.5)
    
    let buttonTagCard = 1, buttonTagDeck = 2, buttonTagBoth = 3
    var selectedCard : Card? {
        didSet {
            if (selectedCard == nil && selectedDeck == nil) {
                self.isDroppedDown = false
            }
            else if (selectedCard == nil && selectedDeck == nil) {
                self.isDroppedDown = false
            }
            else if (selectedCard != nil && oldValue == nil) {
                self.isDroppedDown = true
            }
            if (oldValue != selectedCard) {
                self.refreshContent()
            }
        }
    }
    var selectedDeck : Deck? {
        didSet {
            if (selectedDeck == nil && selectedCard == nil) {
                self.isDroppedDown = false
            }
            else if (selectedCard == nil && selectedDeck == nil) {
                self.isDroppedDown = false
            }
            else if (selectedDeck != nil && oldValue == nil) {
                self.isDroppedDown = true
            }
            if (oldValue != selectedDeck) {
                self.refreshContent()
            }
        }
    }
    
    private var isDroppedDown : Bool {
        didSet {
            if (self.isDroppedDown && !oldValue) {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.frame.origin.y += self.frame.height * 2
                })
            }
            else if (!self.isDroppedDown && oldValue) {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.frame.origin.y -= self.frame.height * 2
                })
            }
        }
    }
    
    @IBOutlet var cardButtons : [UIButton]!
    @IBOutlet var cardLabel : UILabel! {
        didSet {
            print("setcardLabel\n")
        }
    }
    @IBOutlet var deckLabel : UILabel!
    
    override func awakeFromNib() {
        for button in self.cardButtons {
            button.addTarget(self, action: "handleButtonPress:", forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitleColor(disabledTextColor, forState: UIControlState.Disabled)
        }
        super.awakeFromNib()
    }
    
    func handleButtonPress(button: UIButton) {
        switch (button.titleLabel!.text!) {
        case "Flip":
            selectedCard?.flip()
            break
        case "Put on top of selected deck":
            selectedDeck!.insertCardAtIndex(selectedCard!.cardNumber, index: selectedDeck!.sizeOfDeck())
            selectedCard!.removeFromSuperview()
            selectedCard = nil
            break
        case "Put on bottom of selected deck":
            selectedDeck!.insertCardAtIndex(selectedCard!.cardNumber, index: 0)
            selectedCard!.removeFromSuperview()
            selectedCard = nil
            break
        case "Shuffle":
            selectedDeck!.shuffle()
            break
        case "Shuffle into selected deck":
            selectedDeck!.insertCardAtIndex(selectedCard!.cardNumber, index: 0)
            selectedDeck!.shuffle()
            selectedCard!.removeFromSuperview()
            selectedCard = nil
            break
        default:
            print("Button's text is not triggering any action")
            break
        }
    }
    
    func refreshContent() {
        for button in self.cardButtons {
            if ((self.selectedCard == nil && button.tag == buttonTagCard) || (self.selectedDeck == nil && button.tag == buttonTagDeck) || ((self.selectedCard == nil || self.selectedDeck == nil) && button.tag == buttonTagBoth))
            {
                button.enabled = false
            }
            else {
                button.enabled = true
            }
        }
        cardLabel.textColor = selectedCard == nil ? disabledTextColor : labelTextColor
        deckLabel.textColor = selectedDeck == nil ? disabledTextColor : labelTextColor
    }
    
    override init(frame: CGRect) {
        isDroppedDown = false
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        isDroppedDown = false
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context : CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextMoveToPoint(context, self.frame.width / 2 + 40, 10)
        CGContextAddLineToPoint(context, self.frame.width / 2 + 40, self.frame.height - 10)
        CGContextSetRGBStrokeColor(context, 230.0/255.0, 242.0/255.0, 213.0/255.0, 0.7)
        CGContextStrokePath(context)
    }

}
