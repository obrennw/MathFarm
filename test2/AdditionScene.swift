//
//  AdditionScene.swift
//  test2
//
//  Created by Mian Xing on 3/21/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation


private let staticImages = ["bucket2"]
private let movableImages = ["apple"]
private let speaker = AVSpeechSynthesizer()

class AdditionScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {
    // reference to the scene's controller, used for calling back to level selection button
    
    var game_delegate: gameDelegate?
    var correctNum = arc4random_uniform(9)+1
    var answer = 0
    var contactFlag = false
    var selectedNode = SKSpriteNode()


    let questionText = SKLabelNode(fontNamed: "Arial")
    let answerText = SKLabelNode(fontNamed: "Arial")
    let button = SKSpriteNode(imageNamed: "turtle")
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }

    override func didMove(to view: SKView) {
        self.backgroundColor = .red
        self.physicsWorld.contactDelegate = self

        let numA = arc4random_uniform(correctNum)+1
        answerText.fontSize = size.height/7.5
        answerText.text = String(answer)
        answerText.fontColor = .black

        
        questionText.text = String(numA) + " + " + String(correctNum-numA) + " = ?"
        questionText.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        button.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        button.name = "settingsButton"
        button.accessibilityLabel = "back to level selection"
        
        let imageNames = ["bucket2","apple","apple","apple","apple","apple"]
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.isAccessibilityElement = true
            sprite.name = imageName
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width/4,
                                                                   sprite.size.height/4))
            sprite.physicsBody?.affectedByGravity = false
            
            
            if !staticImages.contains(imageName){
                sprite.accessibilityLabel = "apple"
                sprite.physicsBody?.categoryBitMask = ColliderType.Object
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = 0
                sprite.setScale(CGFloat(1.5))
                let offsetFraction = (CGFloat(1) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i-1)))
            }
            else{
                sprite.accessibilityLabel = "bucket"
                sprite.physicsBody?.categoryBitMask = ColliderType.Bucket
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = ColliderType.Object
                sprite.setScale(0.225)
                let offsetFraction = (CGFloat(imageNames.count-1) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height / 2))
                
            }
            self.addChild(sprite)
        }
        
        
        let offsetFraction = (CGFloat(imageNames.count) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
        answerText.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2)
        self.addChild(questionText)
        self.addChild(answerText)
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in:self)
            let touchedNode = self.atPoint(_:positionInScene)
            if(touchedNode is SKSpriteNode) {
                if(touchedNode.name == "settingsButton") {
                    self.game_delegate?.backToLevel()
                }
                else {
                    onSpriteTouch(touchedNode: touchedNode as! SKSpriteNode)
                }
            }
        }
    }
    
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(contactFlag){
            incrementAnswer()
        }
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            print("On bucket")
            speakString(text: "On bucket")
            contactFlag = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            print("Left bucket")
            speakString(text: "Left bucket")
            contactFlag = false
        }
    }
    
    
    private func incrementAnswer(){
        answer += 1
        evaluate()
        answerText.text = String(answer)
        print("Added apple")
        print(answer.description + " apples")
        speakString(text: "Added apple")
        speakString(text: answer.description + " apples")
        contactFlag = false
        selectedNode.removeFromParent()
        print(answer)
    }
    
    private func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * Double.pi)
    }
    
    private func onSpriteTouch(touchedNode: SKSpriteNode) {
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
    
    private func evaluate() {
        if(answer == correctNum){
            // do something
            print("correct!")
        }
    }
    
    private func speakString(text: String) {
        let Utterance = AVSpeechUtterance(string: text)
        speaker.speak(Utterance)
    }
    
}
