//
//  MediumPatternController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/26/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

class MediumPatternController: UIViewController {
    private var currentPattern = [Int]()
    private var currentSelectedAnwer = ""
    private let easyLevelGenerator = PatternLevelEasy()
    private let fx = SoundFX()
    private let defaultEmptyAnswer = #imageLiteral(resourceName: "Unknown-2")
    private let defaultAccessText = "Which animal comes next?"
    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
