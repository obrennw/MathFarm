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

protocol gameDelegate {
    func backToLevel()
}

/// Controller responsible for presenting a given level
class GameViewController: UIViewController, gameDelegate {
    var gameType: String = ""
    /// Called when view is ready to be loaded into contorller
    override func loadView() {
        self.view = SKView()
    }
    
    
    /// Set properties of the Controller once the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /// Configure view and subviews
    override func viewWillLayoutSubviews() {
//        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = true
    
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
                let scene = GameScene(size: skView.frame.size)
                scene.game_delegate = self
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
        //self.removeFromParentViewController()
        //self.navigationController?.popViewController(animated: true)
        super.viewDidDisappear(true)  
        self.dismiss(animated: true, completion: nil)
        //let prevScreen = self.navigationController?.popViewController(animated: true)
        //self.navigationController?.pushViewController(prevScreen!, animated: true)
        //self.performSegue(withIdentifier: "backToLevel", sender: nil)
    }
    

}

