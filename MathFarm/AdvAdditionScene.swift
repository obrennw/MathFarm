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
    var nodeOriginalPosition: CGPoint?
    var answer = 0
    
    let rightObjectType = movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))]
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        
        let submitButtonText = SKLabelNode(fontNamed: "Arial")
        submitButtonText.text = "submit"
        submitButtonText.fontColor = .blue
        let submitButton = SKSpriteNode()
        submitButton.isAccessibilityElement = true
        submitButton.accessibilityLabel = "take the basket to farmer Joe"
        submitButton.color = .red
        submitButton.addChild(submitButtonText)
        self.addChild(submitButton)
        
    }

}
