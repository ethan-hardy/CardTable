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

    required init(coder aDecoder: NSCoder) {
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
        let deckBack = UIImage(named: "backv")
        
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
        
        self.dropDownOptionMenu = DropDownOptionMenu(frame: CGRectMake(0, -0.2 * self.frame.height, self.frame.width, 0.1 * self.frame.height))
        self.overlayView.addSubview(dropDownOptionMenu)
        
        self.frame.origin.y -= self.frame.height / 2
    }
    
    func changeTableView(card:Card?) {
        if (isViewingTable) {
            UIView.animateWithDuration(NSTimeInterval(0.4), animations: { () -> Void in
                self.frame.origin.y -= self.frame.height / 2
                if ((card) != nil) {
                    card!.frame.origin.y += self.frame.height / 2
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
            var card : Card = Card(cardNum: cardNumber, faceUp: false, deck: deck)
            card.userInteractionEnabled = true
            self.tableView.addSubview(card)
            
            if (deck.topCard != nil) {
                deck.topCard.flip()
                self.tableView.bringSubviewToFront(deck.topCard)
                card.center = deck.topCard.center
            }
            else {
                card.center = deck.center
            }
            deck.deckList.removeLastObject()
            deck.topCard = card
        }
    }
    
    func selectCardOrDeck(card: Card) {
        if (card.isTopCardOfDeck) {
            selectedDeckBorder.hidden = false
            selectedDeckBorder.setBorderSizedFrame(card.frame)
            selectedDeckBorder.ownerDeck = card.ownerDeck
        }
        else {
            selectedCardBorder.hidden = false
            selectedCardBorder.setBorderSizedFrame(card.frame)
            selectedCardBorder.ownerCard = card
        }
        self.dropDownOptionMenu.isDroppedDown = true
        self.tableView.bringSubviewToFront(card)
    }
    
    func deselectCard(card: Bool, orDeck: Bool) {
        if (card) {
            selectedCardBorder.hidden = true
            selectedCardBorder.ownerCard = nil
        }
        if (orDeck) {
            selectedDeckBorder.hidden = true
            selectedDeckBorder.ownerDeck = nil
        }
        if (card && orDeck) {
            self.dropDownOptionMenu.isDroppedDown = false
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        touchIsOnTable = true
        self.deselectCard(true, orDeck: true)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        touchIsOnTable = false
    }
    
    func addDeck() {
        deckInstance = Deck(boardOwner: self, centerPoint: CGPointMake(self.frame.width / 2, self.frame.height / 4))
        deckInstance.setupGraphics()
    }
    
}
