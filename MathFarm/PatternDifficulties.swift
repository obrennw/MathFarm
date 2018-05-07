//
//  PatternDifficulties.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/24/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import UIKit


///protocol that details the basic functions a PatternLevel class needs to have
protocol PatternLevel {
    
    /// Get the animal name at the specified index
    ///
    /// - Parameter index: index at which to find the animal at
    /// - Returns: name of the requested animal
    func getAnimalNameAt(index: Int) -> String
    /// Get the animal image at the specified index
    ///
    /// - Parameter index: index at which to find the animal at
    /// - Returns: image of the requested animal
    func getAnimalImageAt(index: Int) -> UIImage
    /// returns the integer representation array of the pattern that is currently chosen
    ///
    /// - Returns: an array of integers representing the pattern
    func getPattern() -> [Int]
    /// takes in an animal name as a string, and determines whether or not that animal is the correct answer given the current pattern
    ///
    /// - Parameter animal: name of the animal chosen
    /// - Returns: true if correct animal, false if not
    func isAnswerCorrect(animal: String) -> Bool
    /// "randomly" chooses a new pattern, sets it as the current pattern, and returns the integer representation of the pattern; an all-in-one function!
    ///
    /// - Returns: the integer array representation of the pattern
    func setAndGetNewPattern() -> [Int]
    /// NOTE: Not completely tested, so may have a bug. Desired functionality: input an animal name as a string and this will return the index of said animal in the array of animalNames; returns -1 if name not found
    ///
    /// - Parameter name: name of the animal
    /// - Returns: the index of the animal
    func getAnimalIndex(name: String) -> Int
    ///an internal func that selects a "random" pattern from the array of possiblePatterns, and sets that as the current pattern
    func setRandomPattern()
}

///this class contains the low-level implementation of the easy pattern difficulty; it contains actual patterns, images, and names of animals
class PatternLevelEasy : PatternLevel {
    /// Varibale to hold the pattern of animals
    private var pattern = [Int]()
    
    ///this array contains all possible patterns that can appear in numerical, integer format; the first 3 integers represent the first animals in the pattern, the 4th int represents the answer, and the last 2 ints are the answer choices
    private let possiblePatterns = ["111101", "000010", "010101", "101010", "222212", "333313", "232332", "313131", "202020", "020220", "131313"] //last 2 elements in each string are answer choices
    
    ///this array contains the images of the animals that correspond to the names
    private let animalImages = [#imageLiteral(resourceName: "cow"), #imageLiteral(resourceName: "pig-308577_960_720"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "cat")] //cow=0, pig=1, dog=2, cat=3
    
    ///this array contains the string names of each animal corresponding to 0,1,2,3 respectively
    private let animalNames = ["cow", "pig", "dog", "cat"]

    ///on initilization of the class, set a random pattern
    init(){
        setRandomPattern()
    }
    
    /// Get the animal name at the specified index
    ///
    /// - Parameter index: index at which to find the animal at
    /// - Returns: name of the requested animal
    public func getAnimalNameAt(index: Int) -> String {
        return animalNames[index]
    }
    
    /// Get the animal image at the specified index
    ///
    /// - Parameter index: index at which to find the animal at
    /// - Returns: image of the requested animal
    public func getAnimalImageAt(index: Int) -> UIImage {
        return animalImages[index]
    }
    
    /// returns the integer representation array of the pattern that is currently chosen
    ///
    /// - Returns: an array of integers representing the pattern
    public func getPattern() -> [Int] {
        return pattern
    }
    
    /// takes in an animal name as a string, and determines whether or not that animal is the correct answer given the current pattern
    ///
    /// - Parameter animal: name of the animal chosen
    /// - Returns: true if correct animal, false if not
    public func isAnswerCorrect(animal: String) -> Bool {
        return animal.elementsEqual(animalNames[pattern[3]])
    }
    
    /// "randomly" chooses a new pattern, sets it as the current pattern, and returns the integer representation of the pattern; an all-in-one function!
    ///
    /// - Returns: the integer array representation of the pattern
    public func setAndGetNewPattern() -> [Int]{
        pattern = [Int]()
        setRandomPattern()
        return pattern
    }
    
    /// NOTE: Not completely tested, so may have a bug. Desired functionality: input an animal name as a string and this will return the index of said animal in the array of animalNames; returns -1 if name not found
    ///
    /// - Parameter name: name of the animal
    /// - Returns: the index of the animal
    public func getAnimalIndex(name: String) -> Int {
        var index = 0
        for ani in animalNames {
            if(ani == name){
                return index
            }
            else {
                index += 1
            }
        }
        return -1
    }
    
    ///an internal func that selects a "random" pattern from the array of possiblePatterns, and sets that as the current pattern
    internal func setRandomPattern(){
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

///this class contains the low-level implementation of the medium (called "pro" in-game) pattern difficulty; it contains actual patterns, images, and names of animals
class PatternLevelMedium : PatternLevel {
    /// array of integers to represent the pattern
    private var pattern = [Int]()
    
    ///this array contains all possible patterns that can appear in numerical, integer format; the first 5 integers represent the first animals in the pattern, the 6th int represents the answer, and the last 2 ints are the answer choices
    private let possiblePatterns = ["01010101", "10101010", "23232323", "30303003", "01201220", "12312330", "22332212", "31031020"]
    
    ///this array contains the images of the animals that correspond to the names
    private let animalImages = [#imageLiteral(resourceName: "cow"), #imageLiteral(resourceName: "pig-308577_960_720"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "cat")] //cow=0, pig=1, dog=2, cat=3
    
    ///this array contains the string names of each animal corresponding to 0,1,2,3 respectively
    private let animalNames = ["cow", "pig", "dog", "cat"]
    
    ///on initilization of the class, set a random pattern
    init(){
        setRandomPattern()
    }
    
    /// Get the animal name at the specified index
    ///
    /// - Parameter index: index at which to find the animal at
    /// - Returns: name of the requested animal
    func getAnimalNameAt(index: Int) -> String {
        return animalNames[index]
    }
    
    /// Get the animal image at the specified index
    ///
    /// - Parameter index: index at which to find the animal at
    /// - Returns: image of the requested animal
    func getAnimalImageAt(index: Int) -> UIImage {
        return animalImages[index]
    }
    
    /// returns the integer representation array of the pattern that is currently chosen
    ///
    /// - Returns: an array of integers representing the pattern
    func getPattern() -> [Int] {
        return pattern
    }
    
    /// takes in an animal name as a string, and determines whether or not that animal is the correct answer given the current pattern
    ///
    /// - Parameter animal: name of the animal chosen
    /// - Returns: true if correct animal, false if not
    func isAnswerCorrect(animal: String) -> Bool {
        return animal.elementsEqual(animalNames[pattern[5]])
    }
    
    /// "randomly" chooses a new pattern, sets it as the current pattern, and returns the integer representation of the pattern; an all-in-one function!
    ///
    /// - Returns: the integer array representation of the pattern
    func setAndGetNewPattern() -> [Int] {
        pattern = [Int]()
        setRandomPattern()
        return pattern
    }
    
    /// NOTE: Not completely tested, so may have a bug. Desired functionality: input an animal name as a string and this will return the index of said animal in the array of animalNames; returns -1 if name not found
    ///
    /// - Parameter name: name of the animal
    /// - Returns: the index of the animal
    func getAnimalIndex(name: String) -> Int {
        var index = 0
        for ani in animalNames {
            if(ani == name){
                return index
            }
            else {
                index += 1
            }
        }
        return -1
    }
    
    ///an internal func that selects a "random" pattern from the array of possiblePatterns, and sets that as the current pattern
    internal func setRandomPattern() {
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
