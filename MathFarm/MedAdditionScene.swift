//
//  MedAdditionScene.swift
//  MathFarm
//
//  Created by Mian Xing on 3/26/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import SpriteKit

/// Module that renders a medium addition game’s current state and maintains its corresponding game logic
class MedAdditionScene: SKScene, SKPhysicsContactDelegate {
    /// A list of static objects
    private let staticImages = ["crate"]
    /// A list of movable objects
    private let movableImages = ["apple", "orange", "peach", "broccoli", "lemon"]
    /// The referenced GameViewController that created this scene. Weak storage is used so that the instance is deleted once the scene is deleted. If strong storage is used here, duplicate untouchable GameViewControllers will be created
    weak var game_delegate: GameViewController?
    /// Boolean that states whether selected Node is in contact with bucket or not
    var contactFlag = false
    /// Boolean that states whether selected Node is moved (drageed) or not. If yes, change the zPosition of the node to be +2 than other nodes, so as to aboid collision
    var movingFlag = false
    /// Boolean that states whether the selected node is recently moved out of crate. Used for Voiceover hinting. P.S that "aus" comes from German and kinda means "out of"
    var ausCrateFlag = false
    /// the node that contains the background
    var backgroundNode = SKSpriteNode(imageNamed: "farmland_background")
    /// The sprite that is currently being touched (if any)
    var selectedNode = SKSpriteNode()
    /// How many times the player has won the current game
    var winningStreak: Int?
    /// Button to return to the memu
    var backButton = SKSpriteNode(imageNamed: "backButton")
    /// same as answer variable, numInCrate keep track of the objects put in the bucket
    var numInCrate = 0
    /// Original position of node currently being moved
    var nodeOriginalPosition: CGPoint?
    /// the type of object that's asked, picked randomly from the list of movableImages
    var rightObjectType = ""
    /// label that shows the current number of objects in crate
    var numberText = SKLabelNode(fontNamed: "Arial")
    /// correctNum is the variable of the answer to the game task, randomly generated with a range btn 1 to 5
    var correctNum = arc4random_uniform(5)+1
    /// one of the question number to appear in the question text, randomly generated within the range of correctNum
    var numA = UInt32(0)
    /// the other question number in question text. numA + numB = correctNum
    var numB = UInt32(0)
    /// The label that shows the task (or question) for the given level
    var gameTask = SKLabelNode(fontNamed: "Arial")
    /// Node that displays the type of object asked for answer.
    var typeNode = SKSpriteNode()
    /// crate node where you have to drag object node to
    var crate = SKSpriteNode(imageNamed: "crate")
    /// label that shows the current number in crate to question
    var numIndicator = SKLabelNode(fontNamed: "Arial")
    /// the list of object nodes you can drag to crate node
    var objList = [String]()
    /// Accessibility label of the winning streak indicator on scene
    var winningStreakText: String?
    /// SoundFX object to play corresponding sounds
    let fx = SoundFX()
    
    /// Initialize the scene by NSCoder
    ///
    /// - Parameter coder: coder used to initialize the scene
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    /// Initialize the scene by size
    ///
    /// - Parameter size: size used to initialize the scene
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    /// Set up sprites on the screen at their correct position
    ///
    /// - Parameter view: The SKView rendering the scene
    override func didMove(to view: SKView) {
        rightObjectType = movableImages[Int(arc4random_uniform(UInt32(movableImages.count)))]
        
        print("winningStreak: ", winningStreak!)
        print(rightObjectType)
        print(correctNum)
        
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
        typeNode = SKSpriteNode(imageNamed: rightObjectType)
        typeNode.size = CGSize(width: 84.0, height: 73.5)
        typeNode.position = CGPoint(x: size.width * 0.75, y: size.height * 0.9)
        typeNode.name = "objShowType"


        // generate & add object nodes
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
        
        // generate streak bar & add to scene
        generateStreakBar()
        self.addChild(backButton)
        self.addChild(gameTask)
        self.addChild(typeNode)
        shiftFocus(node: gameTask)
    }
    
    /// Called when screen is touched
    ///
    /// - Parameters:
    ///   - touches: Set of touches submitted by event
    ///   - event: UIEvent triggering the fucntion
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
    
    /// Handles single finger drag on device and moves touched object if it is a member of movableImages
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
    
    /// Handles event when touch is lifted. Increments score if apple is in contact with pig. Returns object to original position if wrong object of pig or drag went outside of the screen's borders
    ///
    /// - Parameters:
    ///   - touches: Set of touches that caused event
    ///   - event: UIEvent that triggered function
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let adj = CGFloat(40)
        if(selectedNode.position.x > size.width - adj
            || selectedNode.position.x < adj
            || selectedNode.position.y > size.height - adj
            || selectedNode.position.y < adj) {
            selectedNode.position = nodeOriginalPosition!
            speakString(text: "Oops! You just hit the border!")
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
            if(ausCrateFlag) {
                fx.playShortDogSound()
                let updateMsg = "Moved one " + rightObjectType + " out of the crate. The crate now has " + String(numInCrate) + ((numInCrate <= 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s")
                speakString(text: updateMsg)
                ausCrateFlag = false
            }
        }
        //        selectedNode = SKSpriteNode()
    }
    
    /// Called when contact between two objects is initiated
    ///
    /// - Parameter contact: The object that refers to the contact caused by the two objects
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
    
    /// Called when contact between two objects is finished
    ///
    /// - Parameter contact: The object that refers to the contact caused by the two objects
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            print("off crate")
            speakString(text: "off crate")
            contactFlag = false
            if(selectedNode.name == rightObjectType) {
                updateAnswer(node: selectedNode, add: contactFlag)
                ausCrateFlag = true
            }
        }
    }
    
    /// Clears out wobble action from selected node and makes touched node wobble
    ///
    /// - Parameter touchedNode: sprite being touched
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
    
    /// The function that randomly generates a list of 10 objects to be added to the scene. Ensured that the list contains enough right objects to finish the tasks. Returns the generated object list
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
    
    /// Update the score for the level
    private func updateAnswer(node: SKSpriteNode, add: Bool) {
        print("numInCrate before: ", numInCrate)
        numInCrate = (add) ? numInCrate + 1:numInCrate - 1
        crate.accessibilityLabel = "The crate now has " + String(numInCrate) + " " + ((numInCrate<=1) ? rightObjectType: rightObjectType+"s")
        numIndicator.text = String(numInCrate)
        print("numInCrate after: ", numInCrate)
        
        //        contactFlag = false
        
    }
    
    /// evaluate the current answer and the correct number. If matched, remove all "fruit" objects and bucket object then display the victory text and the button to continue playing, or if winning streak is reached, the button to go to next level
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
    
    
    
    /// shake the screen
    ///
    /// this method is credited to https://gist.github.com/mihailt/d793236f31f0b8f8722e
    
    public func shakeCamera(layer:SKSpriteNode, duration:Float) {
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
    
    /// Generate sprites for winning streak bar
    private func generateStreakBar() {
        // first eliminate all streak bar items
        zeroStreakBar()
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
    
    /// helper method for generateStreakBar. Remove prior streak bar nodes before adding new ones
    public func zeroStreakBar() {
        for child in self.children {
            if child.name == "greenlight" {
                child.isAccessibilityElement = false
                child.isUserInteractionEnabled = false
                child.removeFromParent()
            }
        }
    }
    
    /// Called when the correct number of objects are in the crate, removes all other game objects (other than back button), prompts victory text and the button to continue playing, or if winning streak is reached, the button to go to next level.
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
    
    /// Prompts text to be spoken out by device
    ///
    /// - Parameter text: text to be spoken
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




