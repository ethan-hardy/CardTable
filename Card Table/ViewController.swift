//
//  ViewController.swift
//  Swift Stuff
//
//  Created by Ethan Hardy on 2015-07-09.
//  Copyright (c) 2015 Ethan Hardy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var board : BoardView!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //  self.view.backgroundColor = UIColor.blueColor();
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //  self.view.backgroundColor = UIColor.blueColor();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size.height *= 2
        self.view.backgroundColor = UIColor.grayColor();
        board = BoardView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.view.addSubview(board)
        let swipe = UISwipeGestureRecognizer(target: board, action: "changeTableViewFromGestureRecognizer:")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
        swipe.cancelsTouchesInView = false
        board.setupBoard(swipe)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

