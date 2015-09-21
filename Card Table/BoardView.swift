//
//  BoardView.swift
//  Swift Stuff
//
//  Created by Ethan Hardy on 2015-09-13.
//  Copyright (c) 2015 Ethan Hardy. All rights reserved.
//

import UIKit


class BoardView: UIView {
    
    let SELECTED_DECK_BORDER_TAG : Int = 1
    let SELECTED_CARD_BORDER_TAG : Int = 2
    var deckInstance : Deck!
    var numberOfCardsInHand : Int
    var isViewingTable : Bool
    var touchIsOnTable : Bool
    var decksOnTable : NSMutableArray!
    var overlayView : UIView!
    var tableView : UIView!
    var selectedCardBorder : BorderView!
    var selectedDeckBorder : BorderView!
    var dropDownOptionMenu : DropDownOptionMenu!
    var swipeGestureRecognizer : UISwipeGestureRecognizer!
    
    override init(frame: CGRect) {
        numberOfCardsInHand = 0
        isViewingTable = false
        touchIsOnTable = false
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        numberOfCardsInHand = 0
        isViewingTable = false
        touchIsOnTable = false
        super.init(coder: aDecoder)
    }
    
    func setupBoard(swipe: UISwipeGestureRecognizer) {
        self.overlayView = UIView(frame: self.frame)
        self.overlayView.backgroundColor = UIColor.clearColor()
        self.addSubview(overlayView)
        self.tableView = UIView(frame: self.frame)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.addSubview(tableView)
        self.bringSubviewToFront(self.overlayView)
        self.overlayView.userInteractionEnabled = false
     //   self.tableView.userInteractionEnabled = false
        
        let boardBackground = UIImageView(image: UIImage(named: "feltbackground"))
        boardBackground.frame = CGRectMake(0, 0, self.frame.width, self.frame.height / 2)
        self.tableView.addSubview(boardBackground)
        
        self.backgroundColor = UIColor(patternImage: UIImage(named: "crossword")!)
        
        self.userInteractionEnabled = true
        
        swipeGestureRecognizer = swipe
        
        numberOfCardsInHand = 0
        
        decksOnTable = NSMutableArray()
        
        addDeck()
        
        selectedDeckBorder = BorderView(frame: CGRectMake(0, 0, 0, 0))
        selectedDeckBorder.hidden = true
        self.overlayView.addSubview(selectedDeckBorder)
        selectedCardBorder = BorderView(frame: CGRectMake(0, 0, 0, 0))
        selectedCardBorder.hidden = true
        self.overlayView.addSubview(selectedCardBorder)
        
      /*  self.dropDownOptionMenu = DropDownOptionMenu(frame: CGRectMake(0, -0.2 * self.frame.height, self.frame.width, 0.1 * self.frame.height))
        self.overlayView.addSubview(dropDownOptionMenu)
        self.dropDownOptionMenu.setupGraphics()*/
        self.dropDownOptionMenu = DropDownOptionMenu()
        self.dropDownOptionMenu = UINib(nibName: "DropDownOptionMenu", bundle: NSBundle.mainBundle()).instantiateWithOwner(self.dropDownOptionMenu, options: nil)[0] as! DropDownOptionMenu
        self.addSubview(self.dropDownOptionMenu)
        self.dropDownOptionMenu.frame = CGRectMake(0, -0.2 * self.frame.height, self.frame.width, 0.1 * self.frame.height)
        self.dropDownOptionMenu.userInteractionEnabled = true
        self.frame.origin.y -= self.frame.height / 2
        
    //    showFonts()
    }
    
    func changeTableView(card:Card?) {
        if (isViewingTable) {
            UIView.animateWithDuration(NSTimeInterval(0.4), animations: { () -> Void in
                self.frame.origin.y -= self.frame.height / 2
                if ((card) != nil) {
                    card!.frame.origin.y += self.frame.height / 2
                }
                }, completion: { (Bool) -> Void in
                    if ((card) != nil && !card!.isFaceUp) {
                        card!.flip()
                    }
                })
            swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
            isViewingTable = false
        }
        else {
            UIView.animateWithDuration(NSTimeInterval(0.4), animations: { () -> Void in
                self.frame.origin.y += self.frame.height / 2
                if ((card) != nil) {
                    card!.frame.origin.y -= self.frame.height / 2
                }
                })
            swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
            isViewingTable = true
        }
    }
    
    func changeTableViewFromGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        if (touchIsOnTable) {
            changeTableView(nil)
        }
    }

    func drawCardFromDeck(deck: Deck) {
        var cardNumber : Int
        if (deck.deckList.count != 0) {
            cardNumber = deck.deckList.lastObject as! Int
            let card : Card = Card(cardNum: cardNumber, faceUp: false, deck: deck)
            card.userInteractionEnabled = true
            self.tableView.addSubview(card)
            
            var selectCard : Bool = false
            if (deck.topCard != nil) {
                deck.topCard.image = UIImage(named: "backv")
                self.tableView.bringSubviewToFront(deck.topCard)
                card.frame.origin = deck.topCard.frame.origin
                if (self.dropDownOptionMenu.selectedDeck != nil && self.dropDownOptionMenu.selectedDeck!.isEqual(deck)) {
                    selectCard = true
                }
            }
            else {
                card.frame.origin = deck.origin
            }
            deck.deckList.removeLastObject()
            deck.topCard = card
            if (selectCard) {
                self.selectCardOrDeck(card)
            }
        }
    }
    
    func selectCardOrDeck(card: Card) {
        if (card.isTopCardOfDeck) {
            selectedDeckBorder.hidden = false
            selectedDeckBorder.setBorderSizedFrame(card.frame.origin, isZoomSized: false)
            selectedDeckBorder.ownerDeck = card.ownerDeck
            self.dropDownOptionMenu.selectedDeck = card.ownerDeck
        }
        else {
            selectedCardBorder.hidden = false
            selectedCardBorder.setBorderSizedFrame(card.frame.origin, isZoomSized: false)
            selectedCardBorder.ownerCard = card
            self.dropDownOptionMenu.selectedCard = card
        }
        self.tableView.bringSubviewToFront(card)
    }
    
    func deselectCard(card: Bool, orDeck: Bool) {
        if (card) {
            selectedCardBorder.hidden = true
            selectedCardBorder.ownerCard = nil
            self.dropDownOptionMenu.selectedCard = nil
        }
        if (orDeck) {
            selectedDeckBorder.hidden = true
            selectedDeckBorder.ownerDeck = nil
            self.dropDownOptionMenu.selectedDeck = nil
        }
    }
    
  /*  func showFonts() {
        var x : CGFloat = 0.0
        var y : CGFloat = 0.0
        for fontFamilyName in UIFont.familyNames() {
            for fontName in UIFont.fontNamesForFamilyName(fontFamilyName as! String) {
                let font = UIFont(name: fontName as! String, size: 12)
                let label = UILabel(frame: CGRectMake(x, y, 150.0, 15.0))
                label.font = font
                label.text = fontName as? String
                x += 150
                if (x + 150 > self.frame.width) {
                    x = 0
                    y += 15
                }
                self.overlayView.addSubview(label)
            }
        }
    }*/
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!dropDownOptionMenu.frame.contains(touches.first!.locationInView(self))) {
            touchIsOnTable = true
            self.deselectCard(true, orDeck: true)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchIsOnTable = false
    }
    
    func addDeck() {
        deckInstance = Deck(boardOwner: self, originPoint: CGPointMake(self.frame.width / 2, self.frame.height / 4))
        deckInstance.setupGraphics()
    }
    
}
