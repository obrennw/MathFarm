//
//  GameScene.swift
//  draganddrop1
//
//  Created by oqbrennw on 2/5/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation //John

struct ColliderType{
    static let Object:UInt32 = 1
    //1 << 0
    static let Bucket:UInt32 = 2
    //1 << 1
}

private let movableName = "movable"
private let staticName = "not-movable"
private let staticImages = ["bucket2"]
private let Speaker = AVSpeechSynthesizer() //John

class GameScene: SKScene, SKPhysicsContactDelegate {
    let scoreText = SKLabelNode(fontNamed: "Arial")
    let background = SKSpriteNode(imageNamed: "blue-shooting-stars")
    var score = 0
    var selectedNode = SKSpriteNode()
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor.cyan
        print("height:"+String(describing: size.height))
        scoreText.fontSize = size.height/7.5
        scoreText.text = String(score)
        scoreText.fontColor = SKColor.black
        // 1
        //self.background.name = "background"
        //self.background.anchorPoint = CGPoint(x:0,y:0)
        // 2
        //self.addChild(background)
        // 3
        let imageNames = ["apple","apple","apple","apple","apple","bucket2"]
        
        for i in 0..<imageNames.count {
                let imageName = imageNames[i]
                
                let sprite = SKSpriteNode(imageNamed: imageName)
//                if #available(iOS 10.0, *) {
//                    sprite.scale(to: CGSize(width:55,height:55))
//                } else {
//                    // Fallback on earlier versions
//                    sprite.setScale(CGFloat(0.5))
//                }
                sprite.isAccessibilityElement = true
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width / 2,
                                                                       sprite.size.height / 2))
                sprite.physicsBody?.affectedByGravity = false
                //sprite.physicsBody?.isDynamic = false
//                sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height / 2)-(50*CGFloat(i)))
                
                if !staticImages.contains(imageName){
                    sprite.name = movableName
                    sprite.accessibilityLabel = "apple"
                    sprite.physicsBody?.categoryBitMask = ColliderType.Object
                    sprite.physicsBody?.collisionBitMask = 0
                    sprite.physicsBody?.contactTestBitMask = 0
                    sprite.setScale(CGFloat(1.5))
                    let offsetFraction = (CGFloat(1) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                    sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i)))
                }
                else{
                    sprite.name = staticName
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let positionInScene = touch.location(in: self)
            selectNodeForTouch(touchLocation: positionInScene)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("HERE!")
        if (contact.bodyA.categoryBitMask == ColliderType.Object && contact.bodyB.categoryBitMask == ColliderType.Bucket) {
            score += 1
            scoreText.text = String(score)
            SpeakString(text: score.description)
            contact.bodyA.node?.removeFromParent()
            print(score)
        }
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * Double.pi)
    }
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        // 1
        let touchedNode = self.atPoint(_:touchLocation)
        if touchedNode is SKSpriteNode {
            // 2
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                // 3
                if touchedNode.name! == movableName {
                    let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(degree: -5.0), duration: 0.1),
                                                      SKAction.rotate(byAngle: 0.0, duration: 0.1),
                                                      SKAction.rotate(byAngle: degToRad(degree: 5.0), duration: 0.1)])
                    selectedNode.run(SKAction.repeatForever(sequence))
                }
            }
        }
    }
    
    func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position

        if selectedNode.name! == movableName {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let previousPosition = touch.previousLocation(in: self)
            let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
            panForTranslation(translation: translation)
        }
    }
    
    func SpeakString(text: String) { //JOHN
            let Utterance = AVSpeechUtterance(string: text)
            Speaker.speak(Utterance)
    }
}


