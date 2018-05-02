//
//  EasyPatternController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/24/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

class PatternController: UIViewController {
    var currentPattern = [Int]()
    var currentSelectedAnswer = ""
    var animalRow = [UIButton]()
    let fx = SoundFX()
    let defaultEmptyAnswer = #imageLiteral(resourceName: "Unknown-2")
    let defaultAccessText = "Which animal comes next?"
    
    func fillAnimalDetails(){}
    func finishPatternWithImageAndName(image: UIImage, name: String){}
    
    deinit {}
}

class EasyPatternController: PatternController {
    private let easyLevelGenerator = PatternLevelEasy()
    
    @IBOutlet weak var zeroAnimal: UIButton!
    @IBOutlet weak var firstAnimal: UIButton!
    @IBOutlet weak var secondAnimal: UIButton!
    @IBOutlet weak var answerSlot: UIButton!
    @IBOutlet weak var answerChoice0: UIButton!
    @IBOutlet weak var answerChoice1: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPattern = easyLevelGenerator.getPattern()
        animalRow = [zeroAnimal, firstAnimal, secondAnimal]
        fillAnimalDetails()
        fx.playAnimalSound(animal: easyLevelGenerator.getAnimalNameAt(index: currentPattern[0]))
        shiftFocusZeroAnimal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func tappedAnimal(_ sender: UIButton) {
        if(sender.tag < currentPattern.count){
            fx.playAnimalSound(animal: easyLevelGenerator.getAnimalNameAt(index: currentPattern[sender.tag]))
        }
    }
    
    
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
        //speaker.speak(Utterance)
    }
    private func shiftFocusZeroAnimal() {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, zeroAnimal)
    }
    private func shiftFocusContinueButton() {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, continueButton)
    }
}
