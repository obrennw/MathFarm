//
//  EasyPatternController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/24/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

///a parent class that the PatternController classes extend
class PatternController: UIViewController {
    /// current pattern being used for scene
    var currentPattern = [Int]()
    /// answer choice that is currently selected
    var currentSelectedAnswer = ""
    /// row of buttons corresponding to answer
    var animalRow = [UIButton]()
    /// SoundFX object to generate corresponding noises
    let fx = SoundFX()
    /// Default empty answer box image
    let defaultEmptyAnswer = #imageLiteral(resourceName: "Unknown-2")
    /// Default accessibility text for answer box (played when empty)
    let defaultAccessText = "Which animal comes next?"
    ///uses the currently selected pattern to fill in the appropriate images and accessibility labels in the view; also sets tag representing UIButton placement on the screen
    func fillAnimalDetails(){}
    ///responsible for replacing the ? box with the selected answer
    func finishPatternWithImageAndName(image: UIImage, name: String){}
    /// Called when PatternController is destroyed
    deinit {}
}

///this is the controller responsible for the easiest pattern level; all this controller does is alter the storyboard elements in the current view to create patterns
class EasyPatternController: PatternController {
    private let easyLevelGenerator = PatternLevelEasy()
    
    //each of the below outlets are connected to a UIButton element on the screen to be altered throughout the easy pattern game
    
    /// Outlet for zeroAnimal button
    @IBOutlet weak var zeroAnimal: UIButton!
    /// Outlet for firstAnimal button
    @IBOutlet weak var firstAnimal: UIButton!
    /// Outlet for secondAnimal button
    @IBOutlet weak var secondAnimal: UIButton!
    /// Outlet for answerSlot button
    @IBOutlet weak var answerSlot: UIButton!
    /// Outlet for answerChoice0 button
    @IBOutlet weak var answerChoice0: UIButton!
    /// Outlet for answerChoice1 button
    @IBOutlet weak var answerChoice1: UIButton!
    /// Outlet for continueButton button
    @IBOutlet weak var continueButton: UIButton!
    
    
    
    /// Prepares the view to be loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPattern = easyLevelGenerator.getPattern()
        animalRow = [zeroAnimal, firstAnimal, secondAnimal]
        fillAnimalDetails()
        fx.playAnimalSound(animal: easyLevelGenerator.getAnimalNameAt(index: currentPattern[0]))
        shiftFocusZeroAnimal()
    }

    /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///uses the currently selected pattern to fill in the appropriate images and accessibility labels in the view; also sets tag representing UIButton placement on the screen
    override func fillAnimalDetails(){
        zeroAnimal.setBackgroundImage(easyLevelGenerator.getAnimalImageAt(index: currentPattern[0]), for: .normal)
        zeroAnimal.setTitle("", for: .normal)
        zeroAnimal.accessibilityLabel = easyLevelGenerator.getAnimalNameAt(index: currentPattern[0])
        zeroAnimal.tag = 0
        
        firstAnimal.setBackgroundImage(easyLevelGenerator.getAnimalImageAt(index: currentPattern[1]), for: .normal)
        firstAnimal.setTitle("", for: .normal)
        firstAnimal.accessibilityLabel = easyLevelGenerator.getAnimalNameAt(index: currentPattern[1])
        firstAnimal.tag = 1
        
        secondAnimal.setTitle("", for: .normal)
        secondAnimal.setBackgroundImage(easyLevelGenerator.getAnimalImageAt(index: currentPattern[2]), for: .normal)
        secondAnimal.accessibilityLabel = easyLevelGenerator.getAnimalNameAt(index: currentPattern[2])
        secondAnimal.tag = 2
        
        answerChoice0.setBackgroundImage(easyLevelGenerator.getAnimalImageAt(index: currentPattern[4]), for: .normal)
        answerChoice0.setTitle("", for: .normal)
        answerChoice0.accessibilityLabel = "Double tap to select " + easyLevelGenerator.getAnimalNameAt(index: currentPattern[4])
        
        answerChoice1.setBackgroundImage(easyLevelGenerator.getAnimalImageAt(index: currentPattern[5]), for: .normal)
        answerChoice1.setTitle("", for: .normal)
        answerChoice1.accessibilityLabel = "Double tap to select " + easyLevelGenerator.getAnimalNameAt(index: currentPattern[5])
        
    }
    
    ///func that is called when user selected first answer choice possible
    @IBAction func selectAnswer0(_ sender: UIButton) {
        let animalName = easyLevelGenerator.getAnimalNameAt(index: currentPattern[4])
        currentSelectedAnswer = animalName
        finishPatternWithImageAndName(image: easyLevelGenerator.getAnimalImageAt(index: currentPattern[4]), name: animalName)
        answerChoice0.isHidden = true
        answerChoice1.isHidden = false
        answerChoice0.accessibilityLabel = ""
        answerChoice1.accessibilityLabel = "Double tap to select " + easyLevelGenerator.getAnimalNameAt(index: currentPattern[5])
        fx.playAnimalSound(animal: easyLevelGenerator.getAnimalNameAt(index: currentPattern[4]))
        shiftFocusContinueButton()
    }
    
    ///func that is called when user selects second answer choice possible
    @IBAction func selectAnswer1(_ sender: UIButton) {
        let animalName = easyLevelGenerator.getAnimalNameAt(index: currentPattern[5])
        currentSelectedAnswer = animalName
        finishPatternWithImageAndName(image: easyLevelGenerator.getAnimalImageAt(index: currentPattern[5]), name: animalName)
        answerChoice1.isHidden = true
        answerChoice0.isHidden = false
        answerChoice1.accessibilityLabel = ""
        answerChoice0.accessibilityLabel = "Double tap to select " + easyLevelGenerator.getAnimalNameAt(index: currentPattern[4])
        fx.playAnimalSound(animal: easyLevelGenerator.getAnimalNameAt(index: currentPattern[5]))
        shiftFocusContinueButton()
    }
    
    ///plays an animal sound corresponding to the animal that has just been tapped
    @IBAction func tappedAnimal(_ sender: UIButton) {
        if(sender.tag < currentPattern.count){
            fx.playAnimalSound(animal: easyLevelGenerator.getAnimalNameAt(index: currentPattern[sender.tag]))
        }
    }
    
    ///called when user taps the "continue" arrow: if answer is correct, then segues to "great job" screen, else resets answer choice and resumes play of current pattern
    @IBAction func checkAnswer(_ sender: UIButton) {
        if(easyLevelGenerator.isAnswerCorrect(animal: currentSelectedAnswer)){
            fx.playTada()
            performSegue(withIdentifier: "GreatJobEasy", sender: nil)
        }
        else {
            answerChoice0.isHidden = false
            answerChoice1.isHidden = false
            answerSlot.accessibilityLabel = defaultAccessText
            answerSlot.setBackgroundImage(defaultEmptyAnswer, for: .normal)
            answerSlot.tag = 1000
            fx.playClickSound()
            speakString(text: "Wrong animal")
            shiftFocusZeroAnimal()
        }
    }
    
    ///responsible for replacing the ? box with the selected answer
    override func finishPatternWithImageAndName(image: UIImage, name: String){
        answerSlot.setBackgroundImage(image, for: .normal)
        answerSlot.accessibilityLabel = name
    }
    
    func speakString(text: String) {
        //let Utterance = AVSpeechUtterance(string: text)
        while(fx.isPlaying()){
            //wait for song to finish..
            print("waiting...")
        }
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
    }
    
    ///shifts focus of VoiceOver "selection box" to the first animal in the pattern
    private func shiftFocusZeroAnimal() {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, zeroAnimal)
    }
    
    ///shifts focus of the VoiceOver "selection box" to the "continue arrow"; to be called after a user selects an answer choice
    private func shiftFocusContinueButton() {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, continueButton)
    }
}
