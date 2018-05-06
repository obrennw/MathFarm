//
//  PatternViewController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 3/21/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

/// this file is for DEMO purposes!
class PatternViewController: UIViewController {
    
    /// Non-voiceover speaker for Sounds (Not currently being used)
    private let speaker = AVSpeechSynthesizer()
    /// array containing correct choice for each corresponding level
    private let answers = ["Pig"]
    
    /// Reference to box used to display animal submitted for answer
    @IBOutlet weak var greenBox: UIView!
    /// Reference to box that selects pig for answer
    @IBOutlet weak var selectPig: UIButton!

    
    /// Used to implement "frame-based" functions
    var timer = Timer() //
    /// Flag determining whether object is touching screen or not
    var isTouchingScreen = false
    /// Current level of pattern game
    var currentLevel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let intro = "Welcome to pattern recognition. Can you help Farmer Joe figure out how to arrange his animals? Drag your finger across the animals and decide which one comes next in the pattern. Then select your choice at the bottom of the screen. Good luck!"
        speakString(text: intro)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.Update), userInfo: nil, repeats: true) //leaving page needs to invalidate() this timer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func Update(){ //is called once every 0.1 seconds...mimics Unity update function, but DOES NOT run every frame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchingScreen = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchingScreen = false
    }
    
    @IBAction func playCowSound(_ sender: UIButton) {
        if(!speaker.isSpeaking){
            speakString(text: "Cow")
        }
    }
    
    @IBAction func playPigSound(_ sender: UIButton) {
        if(!speaker.isSpeaking){
            speakString(text: "Pig")
        }
    }
    
    @IBAction func selectedAnswer(_ sender: UIButton) {
        if(sender.titleLabel?.text! == "SelectCow"){
            speakString(text: "Sorry. Try again.")
        }
        else {
            greenBox.isHidden = true
            let square_pos = greenBox.frame
            let animal_size = selectPig.frame.size
            selectPig.frame = square_pos
            selectPig.frame.size = animal_size
            selectPig.accessibilityLabel = ""
            speakString(text: "Great job!")
            //play correct animal sound
        }
    }
    
    func speakString(text: String){ //also present in CountingScene.swift...maybe switch to separate file for helper functions
        //let Utterance = AVSpeechUtterance(string: text)
        //speaker.speak(Utterance)
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
    }
    
    public func setLevel(level: Int){
        self.currentLevel = level
    }

}
