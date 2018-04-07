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
private let movableImages = ["apple", "orange", "peach", "broccoli", "lemon"]
//private let speaker = AVSpeechSynthesizer()

class AdditionScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {
    // reference to the scene's controller, used for calling back to level selection button
    
    weak var game_delegate: GameViewController?
    var correctNum = arc4random_uniform(4)+1
    var numA = UInt32(0)
    var answer = 0
    var contactFlag = false
    var selectedNode = SKSpriteNode()
    var winningStreak: Int?
    var nodeOriginalPosition: CGPoint?
    var winningStreakText: String?
    
    
    let rightObjectType = movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))]
   
    


//    let question = SKLabelNode(fontNamed: "Arial")
    
    let questionContainer = SKSpriteNode()
    let question = SKLabelNode(fontNamed: "Arial")
    let answerText = SKLabelNode(fontNamed: "Arial")
    let backButton = SKSpriteNode(imageNamed: "turtle")
    let continueButton = SKLabelNode(fontNamed: "Arial")
    var typeNode = SKSpriteNode()
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }

    override func didMove(to view: SKView) {
        //print("width: ", frame.size.width, " height: ", frame.size.height)
        print(rightObjectType)
        let imageNames = generateObjectList()

        let backgroundNode = SKSpriteNode(imageNamed: "woodenBackground")
        backgroundNode.name = "backGround"
        backgroundNode.size = CGSize(width: size.width, height: size.height)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -3
        
        self.addChild(backgroundNode)
        self.physicsWorld.contactDelegate = self

        answerText.fontSize = size.height/7.5
        answerText.text = String(answer)
        answerText.fontColor = .white
        let offsetFraction = (CGFloat(imageNames.count) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
        print(offsetFraction)
        answerText.position = CGPoint(x: size.width * 0.875, y: size.height / 2)
        self.addChild(answerText)
        
        numA = arc4random_uniform(correctNum)
        let questionTextSpoken = "Please put " + String(numA) + " + " + String(correctNum-numA) + " " + rightObjectType + " into the bucket"
        let questionTextWriten = "Wanted: " + String(numA) + " + " + String(correctNum-numA)
        question.text = questionTextWriten
        question.fontSize = 64
        question.fontColor = .cyan
        question.horizontalAlignmentMode = .center
        question.verticalAlignmentMode = .center
        question.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.9)
        question.isAccessibilityElement = true
        question.accessibilityLabel = questionTextSpoken
        
        typeNode = SKSpriteNode(imageNamed: rightObjectType)
        typeNode.size = CGSize(width: 84.0, height: 73.5)
        typeNode.position = CGPoint(x: size.width * 0.75, y: size.height * 0.9)
        typeNode.name = "objShowType"
        self.addChild(typeNode)
        
        backButton.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        backButton.name = "back to level selection"
        backButton.isAccessibilityElement = true
        backButton.accessibilityLabel = "go back and start a new farm task"
        
        winningStreakText = "You've aced this " + String(winningStreak!) + "time in a roll"
        
        generateStreakBar()
        
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
                sprite.position = CGPoint(x: size.width*0.25, y: size.height*0.15*CGFloat(i))
//                let offsetFraction = (CGFloat(1) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
//                print(offsetFraction)
//                sprite.position = CGPoint(x: size.width * offsetFraction, y: (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i-1)))
//                print("x: ",size.width * offsetFraction, " y: ", (size.height/(1.25))-(1.5*(sprite.size.height)*CGFloat(i-1)))
            }
            else{
                sprite.accessibilityLabel = "bucket"
                sprite.physicsBody?.categoryBitMask = ColliderType.Bucket
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = ColliderType.Object
                sprite.setScale(0.225)
                
                sprite.position = CGPoint(x: size.width * 0.75, y: (size.height / 2))
            }
            self.addChild(sprite)
        }
        


        self.addChild(backButton)
        self.addChild(question)

        
//        let tryButton = SKSpriteNode(imageNamed: "turtle")
//        tryButton.isAccessibilityElement = true
//        tryButton.accessibilityLabel = "this is turtle"
//        tryButton.name = "turtle"
//        tryButton.position = CGPoint(x: frame.size.width / 2, y: frame.size.height*0.3)
//        self.addChild(tryButton)
        
        print("scene ready")
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in:self)
            let touchedNode = self.atPoint(_:positionInScene)
            //print("x: ", positionInScene.x, ", y: ", positionInScene.y)
            
            if(touchedNode is SKSpriteNode) {
                if(touchedNode.name == "back to level selection") {
                    self.game_delegate?.backToLevel()
                }
                else if (touchedNode.name == "greenlight") {
                    speakString(text: winningStreakText!)
                }
                else if (touchedNode.name == "turtle") {
                    let newScene = LevelScene(size: self.size)
                    newScene.game_delegate = self.game_delegate
                    newScene.scaleMode = .aspectFill
                    let transition = SKTransition.moveIn(with: .right, duration: 2)
                    transition.pausesOutgoingScene = true
                    self.scene?.view?.presentScene(newScene, transition: transition)
                } else if (touchedNode.name == "backGround" || touchedNode.name == "objShowType") {
                    return
                }
                else {
                    nodeOriginalPosition = touchedNode.position
                    //print("set original position")
                    onSpriteTouch(touchedNode: touchedNode as! SKSpriteNode)
                }
            } else if(touchedNode.name == "continue") {
                print("continue")
                let newScene = AdditionScene(size: self.size)
                newScene.game_delegate = self.game_delegate
                newScene.winningStreak = self.winningStreak!+1
                newScene.scaleMode = .aspectFill
                print("before presenting scene")
                let transition = SKTransition.moveIn(with: .right, duration: 2)
                transition.pausesOutgoingScene = false
                
                self.scene?.view?.presentScene(newScene)
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
            if(i < 3) {
                    //print("i: ", i)
                    let sprite = SKSpriteNode(imageNamed: "greenlight")
                    sprite.isAccessibilityElement = true
                    sprite.accessibilityLabel = winningStreakText
                    sprite.name = "greenlight"
                    sprite.size = CGSize(width: 70, height: 70)
                    let offset = frame.size.height*0.65 - CGFloat(i)*frame.size.height*0.15
                    //print(offset, " ", frame.size.height*0.9)
                    sprite.position = CGPoint(x:frame.size.width*0.1, y: offset)
                    self.addChild(sprite)
            } else {
                let sprite = SKLabelNode(fontNamed: "Arial")
                sprite.isAccessibilityElement = true
                sprite.accessibilityLabel = "You are now ready to ace more complex tasks for farmer Joe!"
                sprite.text = "Go to next level"
                sprite.name = "toNextLevel"
                sprite.position = CGPoint(x:frame.size.width*0.8, y: frame.size.height*0.1)
                self.addChild(sprite)
                print("a");
                break
            }
        }
    }
    
    
    private func incrementAnswer(){
        answer += 1
        answerText.text = String(answer)
        //print(answer.description + rightObjectType)
        speakString(text: "One " + rightObjectType + " put in the bucket")
        speakString(text: "The bucket now has " + answer.description + " " + rightObjectType)
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
            print("winningStreak: ", winningStreak!+1)
            question.text = "Correct! " + String(numA) + " + " + String(correctNum-numA) + " = " + String(correctNum)
            question.accessibilityLabel = "You got it right! " + String(numA) + " " + rightObjectType + " + " + String(correctNum-numA) + " " + rightObjectType + " = " + String(correctNum) + " " + rightObjectType
            typeNode.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
            continueButton.name = "continue"
            continueButton.text = "continue"
            continueButton.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.7)
            continueButton.isAccessibilityElement = true
            continueButton.accessibilityLabel = "keep helping farmer Joe"
            self.addChild(continueButton)
//            let newScene = AdditionScene(size: self.size)
//            newScene.game_delegate = self.game_delegate
//            newScene.winningStreak = self.winningStreak!+1
//            newScene.scaleMode = .aspectFill
//            print("before presenting scene")
//            let transition = SKTransition.moveIn(with: .right, duration: 2)
//            transition.pausesOutgoingScene = false
//
//            self.scene?.view?.presentScene(newScene)
        }
    }
    
    private func speakString(text: String) {
        //let Utterance = AVSpeechUtterance(string: text)
        //speaker.speak(Utterance)
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
    }
    
}
