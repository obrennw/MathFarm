//
//  CountingScene.swift
//  draganddrop1
//
//  Created by oqbrennw on 2/5/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation
import GameplayKit


/// Describes object for collision type
struct ColliderType{
    /// Object causing the collision
    static let Object:UInt32 = 1
    /// Bucket that recieves the collision
    static let Bucket:UInt32 = 2
}

/// Module that renders a counting level’s current state and maintains its corresponding game logic
class CountingScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {
    
    /// A list of static objects
    private let staticImages = ["pig"]
    
    /// SoundFX object to play corresponding sounds
    private let fx = SoundFX()
    /// A list of movable objects
    private let movableImages = ["apple", "orange", "peach", "broccoli", "lemon"]
    /// Subset of movableImages that is not apples
    private let nonApples = ["orange", "peach", "broccoli", "lemon"]
    /// Sprite that presents the current score
    let scoreText = SKLabelNode(fontNamed: "Arial")
    /// Variable that keeps track of the current store
    var score = 0
    /// The sprite that is currently being touched (if any)
    var selectedNode = SKSpriteNode()
    
    
    
    /// The label that shows the task for the given level
    var question = SKLabelNode(fontNamed: "Arial")
    /// A label with vitory text prompted on sucessful completion of level
    var victory = SKLabelNode(fontNamed: "Arial")
    /// Label that indicates a level was cleared
    var clearedLevel = SKLabelNode(fontNamed: "Arial")
    
    /// Boolean that states whether selected Node is in contact with pig or not
    var contactFlag = false
    
    /// The referenced GameViewController that created this scene. Weak storage is used so that the instance is deleted once the scene is deleted. If strong storage is used here, duplicate untouchable GameViewControllers will be created
    weak var game_delegate:GameViewController?
    
    
    /// How many times the player has won the current game
    var winningStreak: Int?
    /// Original position of node currently being moved
    var nodeOriginalPosition: CGPoint?
    /// Accessibility label for winning streak
    var winningStreakText: String?
    /// Button to return to the memu
    var backButton = SKSpriteNode(imageNamed: "backButton")
    /// Continue Button to go to next scene at same level
    var continueButton = SKSpriteNode(imageNamed: "continueArrow")
    /// The Difficulty for the level. 0 = Easy, 1 = Medium
    var difficulty = 0
    
    /// Randomly generated number of apples to be used for the level
    var numApples = arc4random_uniform(4)+2
    /// Randomly generated number of non apple fruit to be used for the level
    var numNonApples = arc4random_uniform(3)+1

    
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
        var backgroundNode = SKSpriteNode()
        //speakString(text: "Level One")
        if(difficulty == 0){
            numApples = arc4random_uniform(4)+2
            numNonApples = 0
            backgroundNode = SKSpriteNode(imageNamed: "woodenBackground")
        } else if (difficulty == 1){
            numApples = arc4random_uniform(4)+2
            numNonApples = arc4random_uniform(3)+1
            backgroundNode = SKSpriteNode(imageNamed: "grassBackground")
        }
        self.physicsWorld.contactDelegate = self
        
        print("height:"+String(describing: size.height))
        scoreText.fontSize = size.height/7.5
        scoreText.text = String(score)
        scoreText.fontColor = SKColor.white
        scoreText.name = "score"
        scoreText.zPosition = -2
        
        
        //let numApples = arc4random_uniform(11)+1;
        var imageNames = [String]()
        var objects = [String]()
        
        //var backgroundNode = SKSpriteNode(imageNamed: "woodenBackground")
        backgroundNode.name = "backGround"
        backgroundNode.size = CGSize(width: size.width, height: size.height)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -3
        
        self.addChild(backgroundNode)
        self.physicsWorld.contactDelegate = self
        
        //let questionTextSpoken = "Please put " + String(numApples) + "apples into the bucket"
        let questionTextWriten = "Feed the pig " + String(numApples) + " apples"
        question.text = questionTextWriten
        question.fontSize = 64
        question.fontColor = .white
        question.horizontalAlignmentMode = .center
        question.verticalAlignmentMode = .center
        question.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.9)
        question.isAccessibilityElement = true
        question.accessibilityLabel = questionTextWriten
        question.name = "question"
        question.zPosition = -2
        
        backButton.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        backButton.size = CGSize(width: 120.0, height: 120.0)
        backButton.name = "menu"
        backButton.isAccessibilityElement = true
        backButton.accessibilityLabel = "back to menu"
        backButton.zPosition = -2

        
       // winningStreakText = "You've aced this " + String(winningStreak!) + "time in a roll"
        winningStreakText = "Winning streak is at " + String(winningStreak!)
        if(winningStreak! > 3){
            winningStreakText = "Winning streak is over 3. Ready to try new level"
        }
        
        //generateStreakBar()
        //question.accessibilityLabel = questionTextSpoken
        
        
        let nonAppleRandom = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: nonApples)
        let fakeObject = nonAppleRandom[0] as! String
        
        for i in 0..<staticImages.count{
            imageNames.append(staticImages[i])
        }
        for _ in 0..<numApples{
            objects.append("apple")
        }
        
        for _ in 0..<numNonApples{
            objects.append(fakeObject)
        }
        objects = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: objects) as! [String]
        imageNames = imageNames + objects
        var objectOffsetX = 6.0
        //1.5*((Double(numApples)/4.0))+3.0;
        var objectOffsetY = 5.0;
        let offsetFractionRight = CGFloat(5.45/7.0)
        scoreText.position = CGPoint(x: size.width * offsetFractionRight, y: size.height/4)
        self.addChild(scoreText)
        
        
        for i in (0..<imageNames.count) {
            let imageName = imageNames[i]

            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.isAccessibilityElement = true
            sprite.name = imageName
            sprite.accessibilityLabel = imageName
            
            
            if !staticImages.contains(imageName){
                sprite.size = CGSize(width: 90.0, height: 90.0)
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width/4,
                                                                       sprite.size.height/4))
                sprite.physicsBody?.affectedByGravity = false
                sprite.physicsBody?.categoryBitMask = ColliderType.Object
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = 0
                let offsetFractionObject = CGFloat(objectOffsetX)/10
                sprite.position = CGPoint(x: size.width * offsetFractionObject, y: (size.height/(1.25))-(1.1*(sprite.size.height)*CGFloat(objectOffsetY)))
            }
            else{
                sprite.zPosition = -1
                sprite.size = CGSize(width: 210.0, height: 210.0)
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width/4,
                                                                       sprite.size.height/4))
                sprite.physicsBody?.affectedByGravity = false
                sprite.physicsBody?.categoryBitMask = ColliderType.Bucket
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = ColliderType.Object
                
                sprite.physicsBody?.affectedByGravity = false
                sprite.position = CGPoint(x: size.width * offsetFractionRight, y: (size.height / 2))
            }
            objectOffsetY -= 1.5;
            if i%4 == 0 {
                objectOffsetX -= 1.5
                objectOffsetY = 5.0
            }
            self.addChild(sprite)
           
            
        }
        generateStreakBar()
        self.addChild(backButton)
        self.addChild(question)
    }
    
    /// Generate sprites for winning streak bar
    private func generateStreakBar() {
        for i in 0 ..< winningStreak! {
            if(i < 3) {
                //print("i: ", i)
                let sprite = SKSpriteNode(imageNamed: "greenlight")
                if(i == 0){
                    sprite.isAccessibilityElement = true
                }
                sprite.accessibilityLabel = winningStreakText
                sprite.name = "greenlight"
                sprite.size = CGSize(width: 70, height: 70)
                let offset = frame.size.height*0.65 - CGFloat(i)*frame.size.height*0.15
                //print(offset, " ", frame.size.height*0.9)
                sprite.position = CGPoint(x:frame.size.width*0.05, y: offset)
                self.addChild(sprite)
            }
//            else {
//                let sprite = SKLabelNode(fontNamed: "Arial")
//                //sprite.numberOfLines = 0
//                sprite.isAccessibilityElement = true
//                sprite.accessibilityLabel = "Completed!"
//                sprite.text = "Completed!"
//                sprite.name = "levelComplete"
//                sprite.position = CGPoint(x:frame.size.width*0.1, y: frame.size.height*0.1)
//                self.addChild(sprite)
//                //print("a");
//                break
//            }
        }
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
                if(touchedNode.name == "menu") {
                    self.removeAllActions()
                    self.removeAllChildren()
                    //(scene!.view!.window?.rootViewController as! UINavigationController).dismiss(animated: false, completion: nil)
                    self.game_delegate?.backToLevel()
                } else if(touchedNode.name == "continue") {
                    print("continue")
                    let newScene = CountingScene(size: self.size)
                    newScene.game_delegate = self.game_delegate
                    newScene.winningStreak = self.winningStreak!+1
                    newScene.difficulty = difficulty
                    newScene.scaleMode = .aspectFill
                    print("before presenting scene")
                    let transition = SKTransition.moveIn(with: .up, duration: 1)
                    transition.pausesOutgoingScene = false
                    self.removeAllActions()
                    self.removeAllChildren()
                    self.scene?.view?.presentScene(newScene,transition: transition)
                } else {
                    nodeOriginalPosition = touchedNode.position
                    onSpriteTouch(touchedNode: touchedNode as! SKSpriteNode)
                }
            }
        }
    }
    
    /// Called when contact between two objects is initiated
    ///
    /// - Parameter contact: The object that refers to the contact caused by the two objects
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            speakString(text: "On pig")
            print("On pig")
            contactFlag = true
        }
    }
    
    /// Called when contact between two objects is finished
    ///
    /// - Parameter contact: The object that refers to the contact caused by the two objects
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            speakString(text: "Off pig")
            print("Off pig")
            contactFlag = false
        }
    }
    
    
    
    /// Update the score for the level
    func incrementScore(){
        fx.playAnimalSound(animal: "pigShort")
        score += 1
        scoreText.text = String(score)
        print("Added apple")
        print(score.description + " apples")
        if(score == 1){
            speakString(text: score.description + " apple")
        } else {
            speakString(text: score.description + " apples")
        }
        contactFlag = false
        selectedNode.isHidden = true
        selectedNode.accessibilityLabel = ""
        selectedNode.isAccessibilityElement = false
        selectedNode.isUserInteractionEnabled = false
        selectedNode.removeFromParent()
        print(score)
        if(score == numApples){
            onVictory()
        }
    }
    
    /// Called when the correct number of apples are fed to the pig, prompts event text and removes all other game objects (other than back button)
    func onVictory(){
        var backButton = SKSpriteNode()
        for child in self.children {
            if movableImages.contains(child.name!) || staticImages.contains(child.name!) || (child.name == "score") || child.name == "question" {
//                child.isHidden = true
                child.isAccessibilityElement = false
                child.isUserInteractionEnabled = false
                child.removeFromParent()
            } else if child.name == "menu" {
                backButton = child as! SKSpriteNode
//                child.isHidden = true
//                child.isAccessibilityElement = false
//                child.isUserInteractionEnabled = false
                child.removeFromParent()
            }
        }
        //victory.text = "Good Job!"
        fx.playTada()
        if(winningStreak! >= 3){
            while(fx.isPlaying()){
                print("waiting.....")
            }
            fx.playHappy()
        }
        victory.text = "Nice! Counted " + String(numApples) + " apples"
        victory.accessibilityLabel = "Nice!  Counted " + String(numApples) + " Apples"
        victory.fontSize = 70
        victory.fontColor = .white
        victory.horizontalAlignmentMode = .center
        victory.verticalAlignmentMode = .center
        victory.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.6)
        victory.isAccessibilityElement = true
        continueButton.name = "continue"
        //continueButton.text = "continue"
        //continueButton.fontSize = 50
        continueButton.size = CGSize(width: 300.0, height: 300.0)
        continueButton.position = CGPoint(x: frame.size.width * 0.85, y: frame.size.height * 0.15)
        continueButton.isAccessibilityElement = true
        continueButton.accessibilityLabel = "keep helping farmer Joe"
        
        if(winningStreak! >= 3){
            clearedLevel.text = "Cleared Level!"
            victory.text = "Counted " + String(numApples) + " apples"
            clearedLevel.accessibilityLabel = "Cleared Level!"
            clearedLevel.fontSize = 90
            clearedLevel.fontColor = .white
            clearedLevel.horizontalAlignmentMode = .center
            clearedLevel.verticalAlignmentMode = .center
            clearedLevel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.9)
            clearedLevel.isAccessibilityElement = true
        }
        
        self.addChild(clearedLevel)
        self.addChild(continueButton)
        self.addChild(victory)
        generateStreakBar()
        self.addChild(backButton)
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
    
    /// Handles event when touch is lifted (increments score if apple is in contact with pig)
    ///
    /// - Parameters:
    ///   - touches: Set of touches that caused event
    ///   - event: UIEvent that triggered function
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if(contactFlag){
//            incrementScore()
//        }
        let adj = CGFloat(40)
        if(selectedNode.position.x > size.width - adj
            || selectedNode.position.x < adj
            || selectedNode.position.y > size.height - adj
            || selectedNode.position.y < adj) {
            selectedNode.position = nodeOriginalPosition!
        }
        else if(contactFlag){
            if(selectedNode.name == "apple") {
                print("great")
                //add speak string to announce addition
                incrementScore()
            } else {
                print("wrong type of object")
                speakString(text: "wrong type of object")
                contactFlag = false
                selectedNode.position = nodeOriginalPosition!
            }
            print("contact off")
            contactFlag = false
        }
    }
    
    /// Prompts text to be spoken out by device
    ///
    /// - Parameter text: text to be spoken
    func speakString(text: String) {
        //let Utterance = AVSpeechUtterance(string: text)
        while(fx.isPlaying()){
            //wait for song to finish..
            print("waiting...")
        }
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
        //speaker.speak(Utterance)
    }
    
    /// Actions called when instance is destroyed
    deinit {
        print("Deinit CountingScene")
    }
    
}


