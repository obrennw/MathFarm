//
//  MyScene.swift
//  test2
//
//  Created by oqbrennw on 2/28/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import SpriteKit
import UIKit


private let movableName = "movable"
private let staticName = "not-movable"
private let staticImages = ["bucket2"]

class MyScene: SKScene, SKPhysicsContactDelegate {
    private var scoreText : SKLabelNode?
    //let background = SKSpriteNode(imageNamed: "blue-shooting-stars")
    var score = 0
    var selectedNode = SKSpriteNode()
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    override func didMove(to view: SKView) {
        print(self.backgroundColor)
        print(self.backgroundColor==SKColor.red)
        self.backgroundColor = SKColor.cyan
        self.scoreText = childNode(withName: "scoreLabel") as? SKLabelNode
        self.physicsWorld.contactDelegate = self
        print("height:"+String(describing: size.height))
        scoreText?.fontSize = size.height/7.5
        scoreText?.text = String(score)
        scoreText?.fontColor = SKColor.black
        // 1
        //self.background.name = "background"
        //self.background.anchorPoint = CGPoint(x:0,y:0)
        // 2
        //self.addChild(background)
        // 3
        let imageNames = ["apple1","apple2","apple3","apple4","apple5","bucket2"]
        
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            //let spriteImageName = "//"+imageName
            let sprite = childNode(withName: imageName) as? SKSpriteNode
            //                if #available(iOS 10.0, *) {
            //                    sprite.scale(to: CGSize(width:55,height:55))
            //                } else {
            //                    // Fallback on earlier versions
            //                    sprite.setScale(CGFloat(0.5))
            //                }
            sprite?.isAccessibilityElement = true
            sprite?.physicsBody = SKPhysicsBody(circleOfRadius: max((sprite?.size.width)! / 2,
                                                                    (sprite?.size.height)! / 2))
            sprite?.physicsBody?.affectedByGravity = false
            
            if !staticImages.contains(imageName){
                sprite?.name = movableName
                sprite?.accessibilityLabel = "apple"
                sprite?.physicsBody?.categoryBitMask = ColliderType.Object
                sprite?.physicsBody?.collisionBitMask = 0
                sprite?.physicsBody?.contactTestBitMask = 0
                //sprite.setScale(CGFloat(1.5))
                //let offsetFraction = (CGFloat(1) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                //sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i)))
            }
            else{
                sprite?.name = staticName
                sprite?.accessibilityLabel = "bucket"
                sprite?.physicsBody?.categoryBitMask = ColliderType.Bucket
                sprite?.physicsBody?.collisionBitMask = 0
                sprite?.physicsBody?.contactTestBitMask = ColliderType.Object
                //sprite.setScale(0.225)
                //let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                //sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height / 2))
                
            }
            self.addChild(sprite!)
        }
        //let offsetFraction = (CGFloat(imageNames.count) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
        //scoreText.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2)
        self.addChild(scoreText!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let positionInScene = touch.location(in: self)
            onSpriteTouch(touchLocation: positionInScene)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("HERE!")
        if (contact.bodyA.categoryBitMask == ColliderType.Object && contact.bodyB.categoryBitMask == ColliderType.Bucket) {
            score += 1
            scoreText?.text = String(score)
            contact.bodyA.node?.removeFromParent()
            print(score)
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,scoreText?.text)
        }
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * Double.pi)
    }
    
    func onSpriteTouch(touchLocation: CGPoint) {
        let touchedNode = self.atPoint(_:touchLocation)
        if ((touchedNode is SKSpriteNode)) {
            selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
            selectedNode.removeAllActions()
            selectedNode = touchedNode as! SKSpriteNode
            if touchedNode.name! == movableName && !touchedNode.hasActions() {
                let sequence = SKAction.sequence([SKAction.rotate(toAngle: degToRad(degree: -2.0), duration: 0.1),
                                                  SKAction.rotate(toAngle: 0.0, duration: 0.1),
                                                  SKAction.rotate(toAngle: degToRad(degree: 2.0), duration: 0.1)])
                selectedNode.run(SKAction.repeatForever(sequence))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let currentPosition = touch.location(in: self)
            let previousPosition = touch.previousLocation(in: self)
            let translation = CGPoint(x: currentPosition.x - previousPosition.x, y: currentPosition.y - previousPosition.y)
            let nodePosition = selectedNode.position
            if selectedNode.name! == movableName && (self.atPoint(currentPosition).isEqual(selectedNode) || self.atPoint(previousPosition).isEqual(selectedNode)){
                selectedNode.position = CGPoint(x: nodePosition.x + translation.x, y: nodePosition.y + translation.y)
            }
        }
    }
}



