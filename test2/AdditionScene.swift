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
private let movableImages = ["apple", "bird", "cat", "dog"]
private let speaker = AVSpeechSynthesizer()

class AdditionScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {
    // reference to the scene's controller, used for calling back to level selection button
    
    var game_delegate: gameDelegate?
    var correctNum = arc4random_uniform(4)+1
    var answer = 0
    var contactFlag = false
    var selectedNode = SKSpriteNode()
    var winningStreak: Int?
    var nodeOriginalPosition: CGPoint?
    var winningStreakText: String?
    
    
    let rightObjectType = movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))]
   
    


//    let question = SKLabelNode(fontNamed: "Arial")
    
    let answerText = SKLabelNode(fontNamed: "Arial")
    let button = SKSpriteNode(imageNamed: "turtle")
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }

    override func didMove(to view: SKView) {
        //print("width: ", frame.size.width, " height: ", frame.size.height)
        print(rightObjectType)
        self.backgroundColor = .red
        self.physicsWorld.contactDelegate = self

        let numA = arc4random_uniform(correctNum)
        answerText.fontSize = size.height/7.5
        answerText.text = String(answer)
        answerText.fontColor = .black
        
        
        let question = SKLabelNode(fontNamed: "Arial")
        let questionTextSpoken = String(numA) + rightObjectType + " + " + String(correctNum-numA) + rightObjectType + " = ?"
        let questionTextWriiten = String(numA) + " + " + String(correctNum-numA) + " = ?"
        question.text = questionTextWriiten
        question.physicsBody?.categoryBitMask = ColliderType.Bucket
        question.physicsBody?.collisionBitMask = 0
        question.physicsBody?.contactTestBitMask = ColliderType.Object
        question.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        button.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        button.name = "back to level selection"
        button.accessibilityLabel = "back to level selection"
        
        winningStreakText = "You've aced this " + String(winningStreak!) + "time in a roll"
        
        generateStreakBar()
        

        
        let imageNames = generateObjectList()
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.isAccessibilityElement = true
            sprite.name = imageName
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width/4,
                                                                   sprite.size.height/4))
            sprite.physicsBody?.affectedByGravity = false
            
            
            if !staticImages.contains(imageName){
                sprite.accessibilityLabel = imageName
                sprite.physicsBody?.categoryBitMask = ColliderType.Object
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = 0
                sprite.size = CGSize(width: 84.0, height: 73.5)
                //print("height: ",sprite.size.height, " width: ", sprite.size.width)
                let offsetFraction = (CGFloat(1) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i-1)))
                //print("x: ",size.width * offsetFraction, " y: ", (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i-1)))
            }
            else{
                sprite.accessibilityLabel = "bucket"
                sprite.physicsBody?.categoryBitMask = ColliderType.Bucket
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = ColliderType.Object
                sprite.setScale(0.225)
                let offsetFraction = (CGFloat(imageNames.count-1) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
                sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height / 2))
                //print("bucket x: ",size.width * offsetFraction, " bucket y: ", (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i-1)))
            }
            self.addChild(sprite)
        }
        
        
        let offsetFraction = (CGFloat(imageNames.count) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
        answerText.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2)
        self.addChild(question)
        self.addChild(answerText)
        self.addChild(button)
        
        speakString(text: questionTextSpoken)
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in:self)
            let touchedNode = self.atPoint(_:positionInScene)
            //print("x: ", positionInScene.x, ", y: ", positionInScene.y)
            print(touchedNode.name!)
            
            if(touchedNode is SKSpriteNode) {
                if(touchedNode.name == "back to level selection") {
                    speakString(text: "moving to level selection")
                    self.game_delegate?.backToLevel()
                }
                else if (touchedNode.name == "greenlight") {
                    speakString(text: winningStreakText!)
                }
                else {
                    nodeOriginalPosition = touchedNode.position
                    //print("set original position")
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
                if(selectedNode.name == rightObjectType) {
                    incrementAnswer()
                } else {
                    speakString(text: "wrong type of object")
                    contactFlag = false
                    selectedNode.position = nodeOriginalPosition!
                }
            }
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            contactFlag = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            contactFlag = false
        }
    }
    
    private func generateObjectList() -> [String] {
        var objList = ["bucket2"]
        for i in 1...5 {
            if(i<=correctNum) {
                objList.append(rightObjectType)
            } else {
                objList.append(movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))])
            }
        }
        return objList
    }
    
    private func generateStreakBar() {
        for i in 0 ..< winningStreak! {
            if(i<3) {
                //print("i: ", i)
                let sprite = SKSpriteNode(imageNamed: "greenlight")
                sprite.isAccessibilityElement = true
                sprite.accessibilityLabel = winningStreakText
                sprite.name = "greenlight"
                sprite.size = CGSize(width: 70, height: 70)
                let offset = frame.size.width*0.4 + CGFloat(i)*frame.size.width/10
                //print(offset, " ", frame.size.height*0.9)
                sprite.position = CGPoint(x:offset, y: frame.size.height*0.9)
                self.addChild(sprite)
            }
        }
    }
    
    
    private func incrementAnswer(){
        answer += 1
        answerText.text = String(answer)
        //print(answer.description + rightObjectType)
        speakString(text: "Added " + rightObjectType)
        speakString(text: answer.description + rightObjectType)
        contactFlag = false
        selectedNode.removeFromParent()
        print("Answer: " + String(answer))
        evaluate()

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
            // do the following: increment the correct count -> load a new addition scene
            //
            speakString(text: "Good job!")
            winningStreak = winningStreak! + 1
            print("winningStreak: ", winningStreak!)
            let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 1.0)
            let newScene = AdditionScene(size: size)
            newScene.game_delegate = self.game_delegate
            newScene.winningStreak = self.winningStreak
            self.view?.presentScene(newScene, transition: transition)
        }
    }
    
    private func speakString(text: String) {
        let Utterance = AVSpeechUtterance(string: text)
        speaker.speak(Utterance)
    }
    
}
