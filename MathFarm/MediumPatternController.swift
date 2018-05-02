//
//  MediumPatternController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/26/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

class MediumPatternController: PatternController {
    private let mlg = PatternLevelMedium()
    
    @IBOutlet weak var zeroAnimal: UIButton!
    @IBOutlet weak var firstAnimal: UIButton!
    @IBOutlet weak var secondAnimal: UIButton!
    @IBOutlet weak var thirdAnimal: UIButton!
    @IBOutlet weak var fourthAnimal: UIButton!
    @IBOutlet weak var answerSlot: UIButton!
    @IBOutlet weak var answerChoice0: UIButton!
    @IBOutlet weak var answerChoice1: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        currentPattern = mlg.getPattern()
        animalRow = [zeroAnimal, firstAnimal, secondAnimal, thirdAnimal, fourthAnimal]
        fillAnimalDetails()
        fx.playAnimalSound(animal: mlg.getAnimalNameAt(index: currentPattern[0]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func selectAnswer0(_ sender: UIButton) {
        let animalName = mlg.getAnimalNameAt(index: currentPattern[6])
        currentSelectedAnswer = animalName
        finishPatternWithImageAndName(image: mlg.getAnimalImageAt(index: currentPattern[6]), name: animalName)
        answerChoice0.isHidden = true
        answerChoice1.isHidden = false
        answerChoice0.accessibilityLabel = ""
        answerChoice1.accessibilityLabel = "Double tap to select " + mlg.getAnimalNameAt(index: currentPattern[7])
        fx.playAnimalSound(animal: mlg.getAnimalNameAt(index: currentPattern[6]))
    }
    
    @IBAction func selectAnswer1(_ sender: UIButton) {
        let animalName = mlg.getAnimalNameAt(index: currentPattern[7])
        currentSelectedAnswer = animalName
        finishPatternWithImageAndName(image: mlg.getAnimalImageAt(index: currentPattern[7]), name: animalName)
        answerChoice1.isHidden = true
        answerChoice0.isHidden = false
        answerChoice1.accessibilityLabel = ""
        answerChoice0.accessibilityLabel = "Double tap to select " + mlg.getAnimalNameAt(index: currentPattern[6])
        fx.playAnimalSound(animal: mlg.getAnimalNameAt(index: currentPattern[7]))
    }
    
    @IBAction func tappedAnimal(_ sender: UIButton) {
        if(sender.tag < currentPattern.count){
            fx.playAnimalSound(animal: mlg.getAnimalNameAt(index: currentPattern[sender.tag]))
        }
    }
    
    
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
        }
    }
    
    override func finishPatternWithImageAndName(image: UIImage, name: String){
        answerSlot.setBackgroundImage(image, for: .normal)
        answerSlot.accessibilityLabel = name
    }

}
