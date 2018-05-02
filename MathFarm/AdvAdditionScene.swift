//
//  AdvAdditionScene.swift
//  MathFarm
//
//  Created by Mian Xing on 3/26/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import SpriteKit

private let staticImages = ["crate"]
private let movableImages = ["apple", "orange", "peach", "broccoli", "lemon"]

class AdvAdditionScene: SKScene, SKPhysicsContactDelegate {
    weak var game_delegate: GameViewController?
    var contactFlag = false
    var movingFlag = false
    var AusCrateFlag = false
    var backgroundNode = SKSpriteNode(imageNamed: "farmland_background")
    var selectedNode = SKSpriteNode()
    var winningStreak: Int?
    var backButton = SKSpriteNode(imageNamed: "backButton")
    var numInCrate = 0
    var objNumChangce = 0
    var nodeOriginalPosition: CGPoint?
    var rightObjectType = movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))]
    var numberText = SKLabelNode(fontNamed: "Arial")
    var correctNum = arc4random_uniform(9)+1
    var correctObjNum = arc4random_uniform(2)+2
    var fakeCorrectObjNum = arc4random_uniform(2)+1
    var numA = UInt32(0)
    var numB = UInt32(0)
    var gameTask = SKLabelNode(fontNamed: "Arial")
    var typeNode = SKSpriteNode()
    var objTypeList = [String]()
    var objNumList = [String]()
    var winningStreakText: String?
    var fx = SoundFX()

    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        print("winningStreak: ", winningStreak!)
        print(rightObjectType)
        print(correctNum)
        print(correctObjNum)
        print(fakeCorrectObjNum)

        self.physicsWorld.contactDelegate = self

        
        //setup the background
//        let backgroundNode = SKSpriteNode(imageNamed: "farmland_background")
        backgroundNode.name = "backGround"
        backgroundNode.size = CGSize(width: size.width, height: size.height)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -3
        self.addChild(backgroundNode)
        
        //generate a submit button
        let submitButton = SKSpriteNode(imageNamed: "continueArrow")
        submitButton.isAccessibilityElement = true
        submitButton.accessibilityLabel = "submit the crate"
        submitButton.name = "submit"
        submitButton.size = CGSize(width:300, height:300)
        submitButton.position = CGPoint(x:size.width*0.85, y: size.height*0.15)
        self.addChild(submitButton)
        
        //setup the button to go back to level selection
        backButton.position = CGPoint(x: size.width * 0.15, y: size.height * 0.9)
        backButton.size = CGSize(width: 120, height: 120)
        backButton.name = "back to level selection"
        backButton.isAccessibilityElement = true
        backButton.accessibilityLabel = "go back and start a new farm task"
        
        //setup crate node
        let crate = SKSpriteNode(imageNamed: "crate")
        crate.isAccessibilityElement = true
        crate.accessibilityLabel = "crate"
        crate.name = "crate"
        crate.zPosition = -1
        crate.position = CGPoint(x: size.width * 0.7, y: size.height * 0.5)
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 40, y:170), CGPoint(x: -180, y:70), CGPoint(x: -160, y:-40), CGPoint(x: -50, y:-160), CGPoint(x: 180, y:-10), CGPoint(x: 190, y:90), CGPoint(x: 40, y:170)])
        path.closeSubpath()
        crate.physicsBody = SKPhysicsBody(polygonFrom: path)
        crate.physicsBody?.affectedByGravity = false
        crate.physicsBody?.categoryBitMask = ColliderType.Bucket
        crate.physicsBody?.collisionBitMask = 0
        crate.physicsBody?.contactTestBitMask = ColliderType.Object
        self.addChild(crate)

        
        //set up gameTask text node and type indicator node
        numA = arc4random_uniform(correctNum)
        numB = correctNum - numA
        let questionTextSpoken = "Please put " + String(numA) + " + " + String(numB) + " " + ((correctNum<=1||rightObjectType=="broccoli") ? rightObjectType:rightObjectType+"s") + " into the crate"
        let questionTextWriten = "Wanted: " + String(numA) + " + " + String(numB)
        gameTask.name = "gameTask"
        gameTask.text = questionTextWriten
        gameTask.fontSize = 64
        gameTask.fontColor = .black
        gameTask.horizontalAlignmentMode = .center
        gameTask.verticalAlignmentMode = .center
        gameTask.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.9)
        gameTask.isAccessibilityElement = true
        gameTask.accessibilityLabel = questionTextSpoken
        typeNode = SKSpriteNode(imageNamed: rightObjectType)
        typeNode.size = CGSize(width: 84.0, height: 73.5)
        typeNode.position = CGPoint(x: size.width * 0.75, y: size.height * 0.9)
        typeNode.name = "objShowType"
        self.addChild(typeNode)
        
        generateObjList()
        print("list generated")
        var i = 0
        while(!objTypeList.isEmpty && !objNumList.isEmpty) {
            let randomIndex = Int(arc4random_uniform(UInt32(objNumList.count)))
            let randomObjType = objTypeList[randomIndex]
            let randomObjNum = objNumList[randomIndex]
            let sprite = SKSpriteNode(imageNamed: randomObjType)

            sprite.name = randomObjType
            sprite.size = CGSize(width: 108, height: 96)
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width/4,
                                                                   sprite.size.height/4))
            sprite.physicsBody?.affectedByGravity = false
            sprite.physicsBody?.categoryBitMask = ColliderType.Object
            sprite.physicsBody?.collisionBitMask = 0
            sprite.physicsBody?.contactTestBitMask = 0
            let yposition = (i<5) ? CGFloat(size.height*0.15*CGFloat(i+1)):CGFloat(size.height*0.15*CGFloat(i-4))
            let xOffset = (i<5) ? 0.35:0.15
            let xposition = CGFloat(size.width*CGFloat(xOffset))
//            print(xposition)
            sprite.position = CGPoint(x:xposition, y:yposition)
            sprite.zPosition = 0
            let spriteNumText = SKLabelNode(fontNamed:"Arial")
            spriteNumText.name = "number"
            spriteNumText.text = randomObjNum
            spriteNumText.fontColor = .black
            spriteNumText.position = CGPoint(x: -sprite.size.width/2, y: sprite.size.height/2)
            spriteNumText.zPosition = sprite.zPosition+1
            
            sprite.isAccessibilityElement = true
            sprite.accessibilityLabel = randomObjNum + " " + ((randomObjNum == String(1)||randomObjType=="broccoli") ?randomObjType:randomObjType+"s")
            sprite.addChild(spriteNumText)
            self.addChild(sprite)
            objTypeList.remove(at: randomIndex)
            objNumList.remove(at: randomIndex)
            i = i+1
        }
        
        
        generateStreakBar()
        self.addChild(backButton)
        self.addChild(gameTask)
        
        // here force VoiceOver to focus on the gameTask and thus read it out
        shiftFocus(node: gameTask)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in:self)
            let touchedNode = self.atPoint(_:positionInScene)
            if(touchedNode is SKSpriteNode) {
                if (touchedNode.name=="backGround"||touchedNode.name=="objShowType"||touchedNode.name=="crate") {
                    return
                }
                else if (touchedNode.name == "greenlight") {
                    speakString(text: winningStreakText!)
                }
                else if(touchedNode.name == "back to level selection") {
                    self.removeAllActions()
                    self.removeAllChildren()
                    self.game_delegate?.backToLevel()
                }
                else if(touchedNode.name == "continue") {
                    print("continue")
                    let newScene = AdvAdditionScene(size: self.size)
                    newScene.game_delegate = self.game_delegate
                    newScene.winningStreak = self.winningStreak!
                    newScene.scaleMode = .aspectFill
                    let transition = SKTransition.moveIn(with: .right, duration: 1)
                    transition.pausesOutgoingScene = false
                    self.removeAllActions()
                    self.removeAllChildren()
                    self.scene?.view?.presentScene(newScene,transition: transition)
                }
                else if(touchedNode.name == "submit") {
                    print("submit")
                    evaluate()
                }
                else {
                    nodeOriginalPosition = touchedNode.position
                    //print("set original position")
                    touchedNode.zPosition = touchedNode.zPosition+2
                    movingFlag = true
                    print("movingFlag on")
                    print(touchedNode.zPosition)
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
                print("great")
                //add speak string to announce addition
                let updateMsg = "Put " + String(objNumChangce) + ((objNumChangce == 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s") + " into the crate. The crate now has " + String(numInCrate) + ((numInCrate <= 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s")
                speakString(text: updateMsg)
                fx.playCountSound()
            } else {
                print("wrong type of object")
                speakString(text: "wrong type of object")
                contactFlag = false
                selectedNode.position = nodeOriginalPosition!
                print("numInCrate now: ", numInCrate)
            }
            print("contact off")
            contactFlag = false
        } 
        if(movingFlag==true) {
            print("movingFlag off")
            movingFlag = false
            selectedNode.zPosition = selectedNode.zPosition-2
            print(selectedNode.zPosition)
            print("numInCrate now: ", numInCrate)
            //check if the selectednode was moved from crate, if yes announce decrease
            if(AusCrateFlag) {
                let updateMsg = "Moved " + String(objNumChangce) + ((objNumChangce == 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s") + " out of the crate. The crate now has " + String(numInCrate) + ((numInCrate <= 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s")
                speakString(text: updateMsg)
                AusCrateFlag = false
            }
        }
//        selectedNode = SKSpriteNode()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            print("on crate")
            speakString(text: "on crate")
            contactFlag = true
            if(selectedNode.name == rightObjectType) {
                updateAnswer(node: selectedNode, add: contactFlag)
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            print("off crate")
            speakString(text: "off crate")
            contactFlag = false
            if(selectedNode.name == rightObjectType) {
                updateAnswer(node: selectedNode, add: contactFlag)
                AusCrateFlag = true
            }
        }
    }
    
    private func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * Double.pi)
    }
    
    private func onSpriteTouch(touchedNode: SKSpriteNode) {
        selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
        selectedNode.removeAllActions()
        selectedNode = touchedNode
        speakString(text: selectedNode.accessibilityLabel! + " selected")
        if movableImages.contains(touchedNode.name!) && !touchedNode.hasActions() {
            let sequence = SKAction.sequence([SKAction.rotate(toAngle: degToRad(degree: -2.0), duration: 0.1),
                                              SKAction.rotate(toAngle: 0.0, duration: 0.1),
                                              SKAction.rotate(toAngle: degToRad(degree: 2.0), duration: 0.1)])
            selectedNode.run(SKAction.repeatForever(sequence))
        }
    }
    
    private func generateObjList() {
        //setup
        var targetNum = correctNum
        //generate right answer combinations
        for _ in 0 ..< correctObjNum-1 {
            if(targetNum == 0) {break}
            let rightAnsPart = arc4random_uniform(targetNum)+1
            objNumList.append(String(rightAnsPart))
            targetNum -= rightAnsPart
        }
        if(targetNum != 0) {objNumList.append(String(targetNum))}
        //generate some dummy answer of the same type
        for _ in 0 ..< fakeCorrectObjNum {
            objNumList.append(String(arc4random_uniform(correctNum)+1))
        }
        //expand the list to include random numbered answer of random type
//        print(objNumList)
        //sync with type list
        for _ in 0 ..< objNumList.count {
            objTypeList.append(rightObjectType)
        }
//        print(objTypeList)
        //expand both list to 10 count
        for _ in 0 ..< (10-objTypeList.count) {
            objNumList.append(String(arc4random_uniform(correctNum)+1))
            objTypeList.append(
                movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))])
        }
//        print("now")
        print(objTypeList)
        print(objNumList)
        
    }
    private func updateAnswer(node: SKSpriteNode, add: Bool) {
        print("numInCrate before: ", numInCrate)
        var objNum = 0
        if let objTextNode = node.childNode(withName: "number") as? SKLabelNode {
            objNum = Int(objTextNode.text!)!
            print(objNum)
            numInCrate = (add) ? numInCrate + objNum:numInCrate - objNum
        }
        print("numInCrate after: ", numInCrate)
        objNumChangce = objNum
        print("objNumChange: ", objNumChangce)
        
//        contactFlag = false

    }
    
    private func evaluate() {
        if(numInCrate<correctNum) {
            print("too few!")
            fx.playPigSoundShort()
            let errorTextWritten = "Uh-oh..." + String(numA) + " + " + String(numB) + " > " + String(numInCrate)
            let errorTextSpoken = String(numA) + " + " + String(numB) + " is > " + String(numInCrate) + ". Try again!"
//            speakString(text: errorTextWritten)
            gameTask.text = errorTextWritten
            gameTask.fontColor = .yellow
            typeNode.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
            shakeCamera(layer: backgroundNode, duration: 1.0)
            winningStreak = 0
            zeroStreakBar()
            shiftFocus(node: gameTask)
            gameTask.accessibilityLabel = errorTextSpoken
        } else if (numInCrate>correctNum) {
            print("too many!")
            fx.playPigSoundShort()
            let errorTextWritten = "Uh-oh..." + String(numA) + " + " + String(numB) + " < " + String(numInCrate)
            let errorTextSpoken = String(numA) + " + " + String(numB) + " is < " + String(numInCrate) + ". Try again!"
//            speakString(text: errorTextWritten)
            gameTask.text = errorTextWritten
            gameTask.fontColor = .yellow
            typeNode.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
            shakeCamera(layer: backgroundNode, duration: 1.0)
            winningStreak = 0
            zeroStreakBar()
            shiftFocus(node: gameTask)
            gameTask.accessibilityLabel = errorTextSpoken
        } else {
            onVictory()
        }
    }
    
    
/* the following method is credited to https://gist.github.com/mihailt/d793236f31f0b8f8722e */
    
    private func shakeCamera(layer:SKSpriteNode, duration:Float) {
        let position = layer.position
        
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        
        actionsArray.append(SKAction.move(to: position, duration: 0.0))

        let actionSeq = SKAction.sequence(actionsArray);
        layer.run(actionSeq);
    }
    

    private func generateStreakBar() {
        for i in 0 ..< winningStreak! {
            if(i < 7) {
                //print("i: ", i)
                let sprite = SKSpriteNode(imageNamed: "greenlight")
                sprite.isAccessibilityElement = true
                winningStreakText = "You've aced this " + String(winningStreak!) + "time in a roll"
                sprite.accessibilityLabel = winningStreakText
                sprite.name = "greenlight"
                sprite.size = CGSize(width: 50, height: 50)
                let offset = frame.size.height*0.85 - CGFloat(i)*frame.size.height*0.1
                //print(offset, " ", frame.size.height*0.9)
                sprite.position = CGPoint(x:frame.size.width*0.03, y: offset)
                self.addChild(sprite)
            } else {
                print("a");
                break
            }
        }
    }
    
    private func zeroStreakBar() {
        for child in self.children {
            if child.name == "greenlight" {
                child.isAccessibilityElement = false
                child.isUserInteractionEnabled = false
                child.removeFromParent()
            }
        }
    }
    
    private func onVictory() {
        // first erase all nodes in the scene other than back button or background node
        for child in self.children {
            if child.name != "back to level selection" && child.name != "backGround" {
                child.isAccessibilityElement = false
                child.isUserInteractionEnabled = false
                child.removeFromParent()
            }
        }
        
        // update the streak bar
        self.winningStreak! = self.winningStreak! + 1
        generateStreakBar()
        
        fx.playTada()
        if(winningStreak!>7) {
            fx.playHappy()
        }
        // generate the victory text.
        // I hate English plurals.
        let englishPluralIsSuchNonsense = (numA<=1||rightObjectType=="broccoli") ? rightObjectType:rightObjectType+"s"
        let englishPluralIsLousyMath = (numB<=1||rightObjectType=="broccoli") ? rightObjectType:rightObjectType+"s"
        let chineseLiveHappilyWithoutSuchStupidity = (correctNum <= 1||rightObjectType=="broccoli") ? rightObjectType:rightObjectType+"s"
        let victoryTextWritten = "Nice! 😇 " + String(numA) + " + " + String(numB) + " = " + String(numInCrate)
        let victoryTextSpoken = String(numA) + " " + englishPluralIsSuchNonsense + " + " + String(numB) + " " + englishPluralIsLousyMath + " = " + String(correctNum) + " " + chineseLiveHappilyWithoutSuchStupidity + ". Good job!"
        let victoryText = SKLabelNode(fontNamed: "Arial")
        victoryText.text = victoryTextWritten
        victoryText.fontSize = 100
        victoryText.isAccessibilityElement = true
        victoryText.accessibilityLabel = victoryTextSpoken
        victoryText.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        let continueButton = SKSpriteNode(imageNamed: "continueArrow")
        continueButton.name = "continue"
        continueButton.size = CGSize(width: 300, height: 300)
        continueButton.position = CGPoint(x: frame.size.width*0.85, y: frame.size.height * 0.15)
        continueButton.isAccessibilityElement = true
        continueButton.accessibilityLabel = "Tap here to start next task."
        
        self.addChild(continueButton)
        self.addChild(victoryText)
        //if winningStreak is larger than 7 then put some congratulation up
        if(winningStreak! > 7) {
            let congratulateText = SKLabelNode(fontNamed: "Arial")
            congratulateText.text = "You rock! You've mastered the art of mathematic addition!"
            congratulateText.position = CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.4)
            congratulateText.fontColor = .red
            congratulateText.isAccessibilityElement = true
            congratulateText.accessibilityLabel = congratulateText.text
            self.addChild(congratulateText)
        }
        shiftFocus(node: victoryText)
    }
        
    private func shiftFocus(node: SKNode) {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, node)

    }
    func speakString(text: String) {
        //let Utterance = AVSpeechUtterance(string: text)
//        while(fx.isPlaying()){
//            //wait for song to finish..
//            print("waiting...")
//        }
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
        //speaker.speak(Utterance)
    }
}


