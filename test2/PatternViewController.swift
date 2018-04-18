//
//  PatternViewController.swift
//  test2
//
//  Created by John Leland Washburn on 3/21/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

private let speaker = AVSpeechSynthesizer()
private let answers = ["Pig"] //array containing correct choice for each corresponding level


class PatternViewController: UIViewController { //this file is for DEMO purposes!
    
    @IBOutlet weak var greenBox: UIView!
    @IBOutlet weak var selectPig: UIButton!

    
    var timer = Timer() //used to implement "frame-based" functions
    var isTouchingScreen = false
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
    
/*let myVC = storyboard?.instantiateViewControllerWithIdentifier("SecondVC") as! SecondVC
 myVC.stringPassed = myLabel.text!
 navigationController?.pushViewController(myVC, animated: true)*/  //PLACE IN LEVELSELECTCONTROLLER
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
