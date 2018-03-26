//
//  LevelScene.swift
//  test2
//
//  Created by Mian Xing on 3/25/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class LevelScene: SKScene {
    
    var game_delegate: gameDelegate?

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed:"thumbs_cartoon-farm-vector3")
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = -1
        self.addChild(background)
        
        
        let button = SKLabelNode(fontNamed: "Arial")
        button.isAccessibilityElement = true
        button.text = "asdas"
        button.fontColor = .black
        button.accessibilityLabel = "turtle"
        button.name = "turtle"
        button.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        button.zPosition = 1
        button.color = .white
        
        let buttonBackground = SKSpriteNode(color: UIColor.white, size: CGSize(width: button.frame.size.width, height: button.frame.size.height))
        buttonBackground.zPosition = 0
        buttonBackground.color = .white
        buttonBackground.position = CGPoint (x: frame.size.width / 2, y: frame.size.height / 2)
        self.addChild(buttonBackground)
        
        self.addChild(button)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in:self)
            let touchedNode = self.atPoint(_:positionInScene)
            if(touchedNode is SKLabelNode && touchedNode.name == "turtle") {
                let newScene = AdditionScene(size: self.size)
                newScene.game_delegate = self.game_delegate
                newScene.winningStreak = 0
                newScene.scaleMode = .aspectFill
                print("before presenting scene")
                let transition = SKTransition.moveIn(with: .right, duration: 2)
                transition.pausesOutgoingScene = true
                self.scene?.view?.presentScene(newScene, transition: transition)
            }
        }
        
    }
}
