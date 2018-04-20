//
//  AdvAdditionScene.swift
//  MathFarm
//
//  Created by Mian Xing on 3/26/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import SpriteKit

private let staticImages = ["bucket2"]
private let movableImages = ["apple", "bird", "cat", "dog"]

class AdvAdditionScene: SKScene, SKPhysicsContactDelegate {
    weak var game_delegate: GameViewController?
    var contactFlag = false
    var selectedNode = SKSpriteNode()
    var winningStreak: Int?
    var backButton = SKSpriteNode(imageNamed: "turtle")
    var answer = 0
    
    let rightObjectType = movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))]
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        
        let backgroundNode = SKSpriteNode(imageNamed: "woodenBackground")
        backgroundNode.name = "backGround"
        backgroundNode.size = CGSize(width: size.width, height: size.height)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -3
        self.addChild(backgroundNode)
        
        backButton.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        backButton.name = "back to level selection"
        backButton.isAccessibilityElement = true
        backButton.accessibilityLabel = "go back and start a new farm task"
        self.addChild(backButton)

        
//        let submitButtonText = SKLabelNode(fontNamed: "Arial")
//        submitButtonText.text = "submit"
//        submitButtonText.fontColor = .blue
//        let submitButton = SKSpriteNode()
//        submitButton.isAccessibilityElement = true
//        submitButton.accessibilityLabel = "take the basket to farmer Joe"
//        submitButton.color = .red
//        submitButton.addChild(submitButtonText)
//        self.addChild(submitButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in:self)
            let touchedNode = self.atPoint(_:positionInScene)
            
            if(touchedNode is SKSpriteNode) {
                if(touchedNode.name == "back to level selection") {
                    self.removeAllActions()
                    self.removeAllChildren()
                    self.game_delegate?.backToLevel()
                }
            }
        }
    }


}
