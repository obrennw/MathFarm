//
//  MedAdditionScene.swift
//  MathFarm
//
//  Created by Mian Xing on 3/26/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import SpriteKit

class MedAdditionScene: SKScene, SKPhysicsContactDelegate {
    
    private let staticImages = ["crate"]
    private let movableImages = ["apple", "orange", "peach", "broccoli", "lemon"]
    
    weak var game_delegate: GameViewController?
    var contactFlag = false
    var movingFlag = false
    var AusCrateFlag = false
    var backgroundNode = SKSpriteNode(imageNamed: "farmland_background")
    var selectedNode = SKSpriteNode()
    var winningStreak: Int?
    var backButton = SKSpriteNode(imageNamed: "backButton")
    var numInCrate = 0
    var nodeOriginalPosition: CGPoint?
    var rightObjectType = ""
    var numberText = SKLabelNode(fontNamed: "Arial")
    var correctNum = arc4random_uniform(5)+1
    var correctObjNum = arc4random_uniform(2)+2
    var fakeCorrectObjNum = arc4random_uniform(2)+1
    var numA = UInt32(0)
    var numB = UInt32(0)
    var gameTask = SKLabelNode(fontNamed: "Arial")
    var typeNode = SKSpriteNode()
    var crate = SKSpriteNode(imageNamed: "crate")
    var numIndicator = SKLabelNode(fontNamed: "Arial")
    var objList = [String]()
    var errorTextNode = SKLabelNode(fontNamed: "Arial")
    var winningStreakText: String?
    var defaultQuestionSpoken: String?
    let fx = SoundFX()
    
    
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        rightObjectType = movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))]
        
        print("winningStreak: ", winningStreak!)
        print(rightObjectType)
        print(correctNum)
        print(correctObjNum)
        print(fakeCorrectObjNum)
        
        self.physicsWorld.contactDelegate = self
        
        
        //setup the background
        backgroundNode.name = "backGround"
        backgroundNode.size = CGSize(width: size.width, height: size.height)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -3
        self.addChild(backgroundNode)
        
        //generate a submit button
        let submitButton = SKSpriteNode(imageNamed: "continueArrow")
        submitButton.isAccessibilityElement = true
        submitButton.name = "submit"
        submitButton.accessibilityLabel = "submit the crate"
        submitButton.size = CGSize(width:300, height:300)
        submitButton.position = CGPoint(x:size.width*0.85, y: size.height*0.15)
        self.addChild(submitButton)
        
        // we need a status indicator indicating the number in the crate now
        numIndicator.fontSize = 120
        numIndicator.text = String(numInCrate)
        numIndicator.position = CGPoint(x:size.width*0.94, y:size.height/2)
        self.addChild(numIndicator)
        
        //setup the button to go back to level selection
        backButton.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        backButton.size = CGSize(width: 120, height: 120)
        backButton.name = "back to level selection"
        backButton.isAccessibilityElement = true
        backButton.accessibilityLabel = "go back and start a new farm task"
        
        //setup crate node
        crate.isAccessibilityElement = true
        crate.accessibilityLabel = "The crate now has " + String(numInCrate) + " " + ((numInCrate<=1) ? rightObjectType: rightObjectType+"s")
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
        defaultQuestionSpoken = questionTextSpoken
        typeNode = SKSpriteNode(imageNamed: rightObjectType)
        typeNode.size = CGSize(width: 84.0, height: 73.5)
        typeNode.position = CGPoint(x: size.width * 0.75, y: size.height * 0.9)
        typeNode.name = "objShowType"


        
        generateObjList()
        print("list generated")
        var i = 0
        while(!objList.isEmpty) {
            let randomIndex = Int(arc4random_uniform(UInt32(objList.count)))
            let randomObjType = objList[randomIndex]
            let sprite = SKSpriteNode(imageNamed: randomObjType)
            
            sprite.name = randomObjType
            sprite.size = CGSize(width: 108, height: 96)
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width/4, sprite.size.height/4))
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
            sprite.isAccessibilityElement = true
            sprite.accessibilityLabel = randomObjType
            self.addChild(sprite)
            objList.remove(at: randomIndex)
            i = i+1
        }
        

        

        
        errorTextNode.position = gameTask.position
        errorTextNode.isHidden = true
        self.addChild(errorTextNode)
        
        generateStreakBar()
        // need to generate that go to hard level button here
        self.addChild(backButton)
        self.addChild(gameTask)
        self.addChild(typeNode)
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
                else if(touchedNode.name == "continue") {
                    print("continue")
                    let newScene = MedAdditionScene(size: self.size)
                    newScene.game_delegate = self.game_delegate
                    newScene.winningStreak = self.winningStreak!
                    newScene.scaleMode = .aspectFill
                    let transition = SKTransition.moveIn(with: .right, duration: 1)
                    transition.pausesOutgoingScene = false
                    self.removeAllActions()
                    self.removeAllChildren()
                    self.scene?.view?.presentScene(newScene,transition: transition)
                }
                else if(touchedNode.name == "back to level selection") {
                    self.removeAllActions()
                    self.removeAllChildren()
                    self.game_delegate?.backToLevel()
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
            } else {
                if(touchedNode.name == "toNextLevel") {
                    print("toNextLevel")
                    let newScene = AdvAdditionScene(size: self.size)
                    newScene.game_delegate = self.game_delegate
                    newScene.winningStreak = 0
                    newScene.scaleMode = .aspectFill
                    print("before presenting scene")
                    let transition = SKTransition.moveIn(with: .right, duration: 1)
                    transition.pausesOutgoingScene = false
                    self.removeAllActions()
                    self.removeAllChildren()
                    self.scene?.view?.presentScene(newScene,transition: transition)
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
        let adj = CGFloat(40)
        if(selectedNode.position.x > size.width - adj
            || selectedNode.position.x < adj
            || selectedNode.position.y > size.height - adj
            || selectedNode.position.y < adj) {
            selectedNode.position = nodeOriginalPosition!
        }
        if(contactFlag){
            if(selectedNode.name == rightObjectType) {
                print("great")
                fx.playCountSound()
                //add speak string to announce addition
                let updateMsg = "Put one " + rightObjectType + " into the crate. The crate now has " + String(numInCrate) + ((numInCrate <= 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s")
                speakString(text: updateMsg)
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
                let updateMsg = "Moved one " + rightObjectType + " out of the crate. The crate now has " + String(numInCrate) + ((numInCrate <= 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s")
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
        for i in 1 ... 10 {
            if(i<=correctNum) {
                objList.append(rightObjectType)
            } else {
                objList.append(movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))])
            }
        }
        print(objList)
    }
    
    private func updateAnswer(node: SKSpriteNode, add: Bool) {
        print("numInCrate before: ", numInCrate)
        numInCrate = (add) ? numInCrate + 1:numInCrate - 1
        crate.accessibilityLabel = "The crate now has " + String(numInCrate) + " " + ((numInCrate<=1) ? rightObjectType: rightObjectType+"s")
        numIndicator.text = String(numInCrate)
        print("numInCrate after: ", numInCrate)
        
        //        contactFlag = false
        
    }
    
    private func evaluate() {
        if(numInCrate<correctNum) {
            print("too few!")
            fx.playPigSoundShort()
            let errorTextWritten = "Uh-oh..." + String(numA) + " + " + String(numB) + " > " + String(numInCrate)
            let errorTextSpoken = String(numA) + " + " + String(numB) + " is > " + String(numInCrate) + ". Try again!"
            gameTask.text = errorTextWritten
            gameTask.fontColor = .yellow
            typeNode.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
            shakeCamera(layer: backgroundNode, duration: 1.0)
            winningStreak = (winningStreak! <= 2) ?0 : winningStreak! - 2
            generateStreakBar()
            shiftFocus(node: gameTask)
            gameTask.accessibilityLabel = errorTextSpoken

        } else if (numInCrate>correctNum) {
            print("too many!")
            fx.playPigSoundShort()
            let errorTextWritten = "Uh-oh..." + String(numA) + " + " + String(numB) + "  < " + String(numInCrate)
            let errorTextSpoken = String(numA) + " + " + String(numB) + " is < " + String(numInCrate) + ". Try again!"
            gameTask.text = errorTextWritten
            gameTask.fontColor = .yellow
            typeNode.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
            shakeCamera(layer: backgroundNode, duration: 1.0)
            winningStreak = (winningStreak! <= 2) ?0 : winningStreak! - 2
            generateStreakBar()
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
        // first eliminate all streak bar items
        changeStreakBar()
        if(winningStreak == 0) {return}
        for i in 0 ..< winningStreak! {
            if(i < 5) {
                //print("i: ", i)
                let sprite = SKSpriteNode(imageNamed: "greenlight")
                sprite.isAccessibilityElement = true
                winningStreakText = "You've aced this " + String(winningStreak!) + "time in a roll"
                sprite.accessibilityLabel = winningStreakText
                sprite.name = "greenlight"
                sprite.size = CGSize(width: 50, height: 50)
                let yOffset = frame.size.height*0.75 - CGFloat(i)*frame.size.height*0.1
                //print(offset, " ", frame.size.height*0.9)
                sprite.position = CGPoint(x:frame.size.width*0.03, y: yOffset)
                self.addChild(sprite)
            } else {
                // need to generate that go to hard level button here
                let sprite = SKLabelNode(fontNamed: "Arial")
                sprite.isAccessibilityElement = true
                sprite.accessibilityLabel = "You are now ready to ace more complex tasks for farmer Joe!"
                sprite.text = "Go to next level"
                sprite.name = "toNextLevel"
                sprite.position = CGPoint(x:frame.size.width*0.6, y: frame.size.height*0.1)
                self.addChild(sprite)
                print("a");
                break
            }
        }
    }
    
    private func changeStreakBar() {
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
        if(winningStreak!>5) {
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
        shiftFocus(node: victoryText)
        //if winningStreak is larger than 7 then put some congratulation up
        if(winningStreak! > 5) {
            let congratulateText = SKLabelNode(fontNamed: "Arial")
            congratulateText.text = "Well done! You are ready to take on hard addition tasks!"
            congratulateText.position = CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.4)
            congratulateText.fontColor = .red
            congratulateText.isAccessibilityElement = true
            congratulateText.accessibilityLabel = congratulateText.text
            self.addChild(congratulateText)
        }
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



