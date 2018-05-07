//
//  AdvAdditionScene.swift
//  MathFarm
//
//  Created by Mian Xing on 3/26/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import SpriteKit

class AdvAdditionScene: SKScene, SKPhysicsContactDelegate {
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
    var AusCrateFlag = false
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
    /// used to keep track of the number of object node that enters/leaves crate. Used to fulfill the VoiceOver accessibility to announce how many number of objects are put in/ moved outta crate
    var objNumChangce = 0
    /// Original position of node currently being moved
    var nodeOriginalPosition: CGPoint?
    /// the type of object that's asked, picked randomly from the list of movableImages
    var rightObjectType = ""
    /// label that shows the current number of objects in crate
    var numberText = SKLabelNode(fontNamed: "Arial")
    /// correctNum is the variable of the answer to the game task, randomly generated with a range btn 1 to 5
    var correctNum = arc4random_uniform(9)+1
    /// correctObjNum is the number of the object nodes that is guaranteed to constitute a valid solution. There is 2 to 3 of such nodes in each game, with the number of nodes randomly generated
    var correctObjNum = arc4random_uniform(2)+2
        /// fakeCorrectObjNum is the number of the object nodes that is guaranteed to be right object type but added in addition to the guaranteed solution nodes. In a sense they are the "dummy" variable added to confuse the player, but it is possible that the player can use these nodes to construct a valid answer. There is 1 to 2 of such nodes in each game, with the number of nodes randomly generated
    var fakeCorrectObjNum = arc4random_uniform(2)+1
    /// one of the question number to appear in the question text, randomly generated within the range of correctNum
    var numA = UInt32(0)
    /// the other question number in question text. numA + numB = correctNum
    var numB = UInt32(0)
    /// The label that shows the task (or question) for the given level
    var gameTask = SKLabelNode(fontNamed: "Arial")
    /// Node that displays the type of object asked for answer.
    var typeNode = SKSpriteNode()
    /// the list that contains the list of object nodes' type
    var objTypeList = [String]()
    /// the list that contains the list of object nodes' number
    var objNumList = [String]()
    /// Accessibility label of the winning streak indicator on scene
    var winningStreakText: String?
    /// SoundFX object to play corresponding sounds
    var fx = SoundFX()

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
                //add speak string to announce addition
                fx.playCountSound()
                let updateMsg = "Put " + String(objNumChangce) + ((objNumChangce == 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s") + " into the crate. The crate now has " + String(numInCrate) + ((numInCrate <= 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s")
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
                fx.playShortDogSound()
                let updateMsg = "Moved " + String(objNumChangce) + ((objNumChangce == 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s") + " out of the crate. The crate now has " + String(numInCrate) + ((numInCrate <= 1||rightObjectType=="broccoli") ?rightObjectType:rightObjectType+"s")
                speakString(text: updateMsg)
                AusCrateFlag = false
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
                AusCrateFlag = true
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
    
    /// the function that randomly generate two list of ten strings, one stating the object type of object node and the other the number the corresponding node carries. It conforms that: There is at least one correct solution; that minimum solution takes 2 - 3 nodes; there will be 1 - 2 guaranteed "dummy" variables.
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
    
    /// Update the score for the level
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
    
    /// evaluate the current answer and the correct number. If matched, remove all "fruit" objects and bucket object then display the victory text and the button to continue playing, or if winning streak is reached, the button to go to next level
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
    
    
    /// shake the screen
    ///
    /// this method is credited to https://gist.github.com/mihailt/d793236f31f0b8f8722e
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
    
    /// Generate sprites for winning streak bar
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
    
    /// helper method for generateStreakBar. Remove prior streak bar nodes before adding new ones
    private func zeroStreakBar() {
        for child in self.children {
            if child.name == "greenlight" {
                child.isAccessibilityElement = false
                child.isUserInteractionEnabled = false
                child.removeFromParent()
            }
        }
    }
    
    /// Called when the correct number of objects are in the crate, removes all other game objects (other than back button), prompts victory text and the button to continue playing, or if winning streak is reached, the button to go to next level.
    ///
    /// P.S I'm lazy and this is mostly a duplicate of MedAdditionScene function, as is the generateStreakBar above and many others. A better design decision would be to merge MedAdditionScene and AdvAdditionScene, thus avoiding so many duplication. But again I'm lazy and don't care so long as it works. 
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


