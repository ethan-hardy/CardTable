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
    var center : CGPoint
    weak var board : BoardView?
    
    init(boardOwner: BoardView, centerPoint: CGPoint) {
        deckList = NSMutableArray()
        for cardNumber in 1...52 {
            deckList.addObject(cardNumber);
        }
        isMoveEnabled = false
        board = boardOwner
        center = centerPoint
    }
    
    func setupGraphics() {
        self.shuffle()
        board?.drawCardFromDeck(self)
    }
    
    func shuffle() {
        var deckHold : NSMutableArray = NSMutableArray()
        while (deckList.count > 0) {
            let randomInt = Int(arc4random() % UInt32(deckList.count))
            deckHold.addObject(deckList.objectAtIndex(randomInt))
            deckList.removeObjectAtIndex(randomInt)
        }
        deckList = deckHold
    }
}
