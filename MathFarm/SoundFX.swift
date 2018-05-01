//
//  AnimalSoundFX.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/25/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import AVFoundation

class SoundFX {
    private var audioPlayer : AVAudioPlayer?
    private let pigURL = Bundle.main.url(forResource: "pigfarm", withExtension: "mp3")
    private let cowURL = Bundle.main.url(forResource: "cowmoo", withExtension: "mp3")
    private let catURL = Bundle.main.url(forResource: "meow", withExtension: "mp3")
    private let tadaURL = Bundle.main.url(forResource: "tada", withExtension: "mp3")
    private let dogURL = Bundle.main.url(forResource: "bark", withExtension: "mp3")
    
    public func playAnimalSound(animal: String) -> Bool {
        switch(animal){
        case "pig":
            playPigSound()
            break
            
        case "cow":
            playCowSound()
            break
            
        case "dog":
            playDogSound()
            break
            
        case "cat":
            playCatSound()
            break
            
        default:
            //no sound
            return false
        }
        return true
    }
    
    public func playTada(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tadaURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    private func playPigSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pigURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    private func playCowSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: cowURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    private func playDogSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: dogURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    private func playCatSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: catURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
}

