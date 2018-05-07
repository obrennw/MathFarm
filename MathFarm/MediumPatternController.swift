//
//  MediumPatternController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/26/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

///this is the controller responsible for the medium ("pro") pattern level; all this controller does is alter the storyboard elements in the current view to create patterns...class is incredibly similar to EasyPatternController, but this accounts for the larger amount of animals
class MediumPatternController: PatternController {
     /// A pattern level easy variable for holding the PatternLevelEasy() class which has the code to generate random animals
    private let mlg = PatternLevelMedium()
    
    /// Outlet for zeroAnimal button
    @IBOutlet weak var zeroAnimal: UIButton!
    /// Outlet for firstAnimal button
    @IBOutlet weak var firstAnimal: UIButton!
    /// Outlet for secondAnimal button
    @IBOutlet weak var secondAnimal: UIButton!
    /// Outlet for thirdAnimal button
    @IBOutlet weak var thirdAnimal: UIButton!
    /// Outlet for fourthAnimal button
    @IBOutlet weak var fourthAnimal: UIButton!
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
        currentPattern = mlg.getPattern()
        animalRow = [zeroAnimal, firstAnimal, secondAnimal, thirdAnimal, fourthAnimal]
        fillAnimalDetails()
        fx.playAnimalSound(animal: mlg.getAnimalNameAt(index: currentPattern[0]))
        shiftFocusZeroAnimal()
    }

    /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///uses the currently selected pattern to fill in the appropriate images and accessibility labels in the view; also sets tag representing UIButton placement on the screen
    override func fillAnimalDetails() {
        var count = 0
        for animal in animalRow {
            animal.setBackgroundImage(mlg.getAnimalImageAt(index: currentPattern[count]), for: .normal)
            animal.accessibilityLabel = mlg.getAnimalNameAt(index: currentPattern[count])
            animal.tag = count
            count += 1
        }
        
        answerChoice0.setBackgroundImage(mlg.getAnimalImageAt(index: currentPattern[6]), for: .normal)
        answerChoice0.accessibilityLabel = "Double tap to select " + mlg.getAnimalNameAt(index: currentPattern[6])
        
        answerChoice1.setBackgroundImage(mlg.getAnimalImageAt(index: currentPattern[7]), for: .normal)
        answerChoice1.accessibilityLabel = "Double tap to select " + mlg.getAnimalNameAt(index: currentPattern[7])
    }
    
    ///func that is called when user selected first answer choice possible
    @IBAction func selectAnswer0(_ sender: UIButton) {
        let animalName = mlg.getAnimalNameAt(index: currentPattern[6])
        currentSelectedAnswer = animalName
        finishPatternWithImageAndName(image: mlg.getAnimalImageAt(index: currentPattern[6]), name: animalName)
        answerChoice0.isHidden = true
        answerChoice1.isHidden = false
        answerChoice0.accessibilityLabel = ""
        answerChoice1.accessibilityLabel = "Double tap to select " + mlg.getAnimalNameAt(index: currentPattern[7])
        fx.playAnimalSound(animal: mlg.getAnimalNameAt(index: currentPattern[6]))
        shiftFocusContinueButton()
    }
    
    ///func that is called when user selected second answer choice possible
    @IBAction func selectAnswer1(_ sender: UIButton) {
        let animalName = mlg.getAnimalNameAt(index: currentPattern[7])
        currentSelectedAnswer = animalName
        finishPatternWithImageAndName(image: mlg.getAnimalImageAt(index: currentPattern[7]), name: animalName)
        answerChoice1.isHidden = true
        answerChoice0.isHidden = false
        answerChoice1.accessibilityLabel = ""
        answerChoice0.accessibilityLabel = "Double tap to select " + mlg.getAnimalNameAt(index: currentPattern[6])
        fx.playAnimalSound(animal: mlg.getAnimalNameAt(index: currentPattern[7]))
        shiftFocusContinueButton()
    }
    
    ///plays an animal sound corresponding to the animal that has just been tapped
    @IBAction func tappedAnimal(_ sender: UIButton) {
        if(sender.tag < currentPattern.count){
            fx.playAnimalSound(animal: mlg.getAnimalNameAt(index: currentPattern[sender.tag]))
        }
    }
    
    ///called when user taps the "continue" arrow: if answer is correct, then segues to "great job" screen, else resets answer choice and resumes play of current pattern
    @IBAction func checkAnswer(_ sender: UIButton) {
        if(mlg.isAnswerCorrect(animal: currentSelectedAnswer)){
            fx.playTada()
            performSegue(withIdentifier: "GreatJobMed", sender: nil)
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
    
     ///shifts focus of VoiceOver "selection box" to the first animal in the pattern
    private func shiftFocusZeroAnimal() {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, zeroAnimal)
    }
    
    ///shifts focus of the VoiceOver "selection box" to the "continue arrow"; to be called after a user selects an answer choice
    private func shiftFocusContinueButton() {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, continueButton)
    }

}
