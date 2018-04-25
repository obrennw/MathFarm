//
//  PatternDifficulties.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/24/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import UIKit

class PatternLevelEasy { //make parent class eventually
    private var pattern = [Int]()
    private let possiblePatterns = ["111101", "000010", "010101", "101010", "222212", "333313", "232332", "313131", "202020", "020220"] //last 2 elements in each string are answer choices
    private let animalImages = [#imageLiteral(resourceName: "49-Free-Cartoon-Cow-Clip-Art"), #imageLiteral(resourceName: "pig-308577_960_720"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "cat")] //cow=0, pig=1, dog=2, cat=3
    private let animalNames = ["cow", "pig", "dog", "cat"]

    init(){
        setRandomPattern()
    }
    
    public func getAnimalNameAt(index: Int) -> String {
        return animalNames[index]
    }
    
    public func getAnimalImageAt(index: Int) -> UIImage {
        return animalImages[index]
    }
    
    public func getPattern() -> [Int] {
        return pattern
    }
    
    public func isAnswerCorrect(animal: String) -> Bool {
        return animal.elementsEqual(animalNames[pattern[3]])
    }
    
    public func setAndGetNewPattern() -> [Int]{
        pattern = [Int]()
        setRandomPattern()
        return pattern
    }
    
    public func getAnimalIndex(name: String) -> Int{
        var index = 0
        for ani in animalNames {
            if(ani.elementsEqual(name)){
                return index
            }
            else {
                index += 1
            }
        }
        return -1
    }
    
    private func setRandomPattern(){
        let rand = Int(arc4random_uniform(UInt32(possiblePatterns.count)))
        let str = possiblePatterns[rand]
        
        for char in str {
            let a = String(char)
            if let int = Int(a) {
                pattern += [int]
            }
        }
    }
}

class PatternLevelMedium {
    
}

class PatternLevelHard {
    
}
