//
//  EasyPatternController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/24/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

class EasyPatternController: UIViewController {
    private var currentPattern = [Int]()
    private let image = #imageLiteral(resourceName: "49-Free-Cartoon-Cow-Clip-Art")
    private let easyLevelGenerator = PatternLevelEasy()
    
    @IBOutlet weak var zeroAnimal: UIButton!
    @IBOutlet weak var firstAnimal: UIButton!
    @IBOutlet weak var secondAnimal: UIButton!
    @IBOutlet weak var thirdAnimal: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPattern = easyLevelGenerator.getPattern()
        fillAnimalDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillAnimalDetails(){
        //zeroAnimal.setBackgroundImage(image, for: .normal)
        //zeroAnimal.setTitle( "Why button no work", for: .normal)
    }
}
