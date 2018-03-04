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

class GameViewController: UIViewController {
    
    override func loadView() {
        self.view = SKView()
    }
    
    
    /// Set properties of the Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    /// Configure view and subviews
    override func viewWillLayoutSubviews() {
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        //Set scene and load it into the view
        let scene = GameScene(size: skView.frame.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    
    /// Whether device should rotate or not on promt
    override var shouldAutorotate: Bool {
        return true
    }
    
    /// Set supported orientations of device for the application
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    /// Release any cached data, images, etc that aren't in use.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Set preference for visibility of status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

