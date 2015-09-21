//
//  Deck.swift
//  Swift Stuff
//
//  Created by Ethan Hardy on 2015-09-15.
//  Copyright (c) 2015 Ethan Hardy. All rights reserved.
//

import UIKit

class Deck : NSObject {
    
    var deckList : NSMutableArray
    var topCard : Card!
    var lastTouch : CGPoint!
    var isMoveEnabled : Bool
    var origin : CGPoint
    weak var board : BoardView?
    
    init(boardOwner: BoardView, originPoint: CGPoint) {
        deckList = NSMutableArray()
        for cardNumber in 1...52 {
            deckList.addObject(cardNumber);
        }
        isMoveEnabled = false
        board = boardOwner
        origin = originPoint
    }
    
    func setupGraphics() {
        self.shuffle()
        board?.drawCardFromDeck(self)
    }
    
    func sizeOfDeck() -> Int {
        return deckList.count
    }
    
    func shuffle() {
        let deckHold : NSMutableArray = NSMutableArray()
        while (deckList.count > 0) {
            let randomInt = Int(arc4random() % UInt32(deckList.count))
            deckHold.addObject(deckList.objectAtIndex(randomInt))
            deckList.removeObjectAtIndex(randomInt)
        }
        deckList = deckHold
        refreshTopCard()
    }
    
    func insertCardAtIndex(cardNumber: Int, index: Int) { //if you pass a card already in the deck, you will end up with two of them
        deckList.insertObject(cardNumber, atIndex: index)
        if (index == sizeOfDeck()-1) {
            refreshTopCard()
        }
    }
    
    private func refreshTopCard() {
        if (self.topCard != nil) {
            let cardNum = self.topCard.cardNumber
            self.topCard.cardNumber = self.deckList.lastObject as! Int
            self.deckList.replaceObjectAtIndex(sizeOfDeck()-1, withObject: cardNum)
            self.deckList.removeLastObject()
        }
    }
}
