//
//  GameViewController.swift
//  draganddrop1
//
//  Created by oqbrennw on 2/5/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

/// Controller responsible for presenting a given level
class GameViewController: UIViewController {
    
    /// Key that determines which type of scene is generated
    var gameType: String = ""
    
    /// Called when view is ready to be loaded into contorller
        override func loadView() {
           self.view = SKView()
        }
    
    
    /// Set properties of the Controller once the view is loaded
    /// expected behavior: based on the value of gameType load counting game or addition game
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Configure view and subviews
    override func viewWillLayoutSubviews() {
        //Set scene and accordingly & load it into the view
        if let skView = self.view as! SKView? {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            switch gameType {
            case "addition":
                let scene = AdditionScene(size: skView.frame.size)
                scene.game_delegate = self
                scene.winningStreak = 0
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            case "counting":
                let scene = CountingScene(size: skView.frame.size)
                scene.game_delegate = self
                scene.winningStreak = 0
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            default: break
            }
        }
    }

    /// Release any cached data, images, etc that aren't in use.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
        /// Set preference for visibility of status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: game delegate
    func backToLevel() {
        if let skView = self.view as! SKView? {
            skView.presentScene(nil)
            self.dismiss(animated: true)
            //self.performSegue(withIdentifier: "unwindGame", sender: self)
        }
    }
    
    /// Actions called when instance is destroyed
    deinit {
        print("Deinit GameViewController")
    }
        

}

