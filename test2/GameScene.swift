//
//  GameScene.swift
//  draganddrop1
//
//  Created by oqbrennw on 2/5/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

/// Describes object for collision type
struct ColliderType{
    static let Object:UInt32 = 1
    static let Bucket:UInt32 = 2
}

/// A list of static objects
private let staticImages = ["bucket2"]
/// A list of movable objects
private let movableImages = ["apple"]

private let Speaker = AVSpeechSynthesizer()

class GameScene: SKScene, SKPhysicsContactDelegate {
    let scoreText = SKLabelNode(fontNamed: "Arial")
    let background = SKSpriteNode(imageNamed: "blue-shooting-stars")
    var score = 0
    
    //The sprite currently being touched (if any)
    var selectedNode = SKSpriteNode()
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    /// Called when scene is presented
    ///
    /// - Parameter view: The SKView rendering the scene
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor.cyan
        
        print("height:"+String(describing: size.height))
        scoreText.fontSize = size.height/7.5
        scoreText.text = String(score)
        scoreText.fontColor = SKColor.black
        
        let imageNames = ["apple","apple","apple","apple","apple","bucket2"]
        
        for i in 0..<imageNames.count {
                let imageName = imageNames[i]

                let sprite = SKSpriteNode(imageNamed: imageName)
                sprite.isAccessibilityElement = true
                sprite.name = imageName
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width / 2,
                                                                       sprite.size.height / 2))
                sprite.physicsBody?.affectedByGravity = false

                
                if !staticImages.contains(imageName){
                    sprite.accessibilityLabel = "apple"
                    sprite.physicsBody?.categoryBitMask = ColliderType.Object
                    sprite.physicsBody?.collisionBitMask = 0
                    sprite.physicsBody?.contactTestBitMask = 0
                    sprite.setScale(CGFloat(1.5))
                    let offsetFraction = (CGFloat(1) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                    sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i)))
                }
                else{
                    sprite.accessibilityLabel = "bucket"
                    sprite.physicsBody?.categoryBitMask = ColliderType.Bucket
                    sprite.physicsBody?.collisionBitMask = 0
                    sprite.physicsBody?.contactTestBitMask = ColliderType.Object
                    sprite.setScale(0.225)
                    let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                    sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height / 2))
                    
                }
                self.addChild(sprite)
        }
        let offsetFraction = (CGFloat(imageNames.count) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
        scoreText.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2)
        self.addChild(scoreText)
    }
    
    /// Called when screen is touched
    ///
    /// - Parameters:
    ///   - touches: Set of touches submitted by event
    ///   - event: UIEvent triggering the fucntion
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(_:positionInScene)
            if (touchedNode is SKSpriteNode){
                onSpriteTouch(touchedNode: touchedNode as! SKSpriteNode)
            }
        }
    }
    
    /// Called when contact between two objects is initiated
    ///
    /// - Parameter contact: The object that refers to the contact caused by the two objects
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Object && contact.bodyB.categoryBitMask == ColliderType.Bucket) {
            score += 1
            scoreText.text = String(score)
            SpeakString(text: score.description)
            contact.bodyA.node?.removeFromParent()
            print(score)
        }
    }
    
    /// Converts degrees to radians
    ///
    /// - Parameter degree: value in degrees
    /// - Returns: converted value in radians
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * Double.pi)
    }
    
    /// Clears out wobble action from selected node and makes touched node wobble
    ///
    /// - Parameter touchedNode: sprite being touched
    func onSpriteTouch(touchedNode: SKSpriteNode) {
        selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
        selectedNode.removeAllActions()
        selectedNode = touchedNode
        if movableImages.contains(touchedNode.name!) && !touchedNode.hasActions() {
            let sequence = SKAction.sequence([SKAction.rotate(toAngle: degToRad(degree: -2.0), duration: 0.1),
                                              SKAction.rotate(toAngle: 0.0, duration: 0.1),
                                              SKAction.rotate(toAngle: degToRad(degree: 2.0), duration: 0.1)])
            selectedNode.run(SKAction.repeatForever(sequence))
        }
    }
    
    /// Handles single finger drag on device
    ///
    /// - Parameters:
    ///   - touches: Set of touches that caused event
    ///   - event: UIEvent that triggered function
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //Drag sprite to new position if it is being touched
            let nodePosition = selectedNode.position
            let currentPosition = touch.location(in: self)
            let previousPosition = touch.previousLocation(in: self)
            let translation = CGPoint(x: currentPosition.x - previousPosition.x, y: currentPosition.y - previousPosition.y)
            if  ((self.atPoint(currentPosition).isEqual(selectedNode) || self.atPoint(previousPosition).isEqual(selectedNode)
                ) && movableImages.contains(selectedNode.name!)){
                selectedNode.position = CGPoint(x: nodePosition.x + translation.x, y: nodePosition.y + translation.y)
            }
        }
    }
    
    /// Prompts text to be spoken out by device
    ///
    /// - Parameter text: text to be spoken
    func SpeakString(text: String) {
            let Utterance = AVSpeechUtterance(string: text)
            Speaker.speak(Utterance)
    }
}

