//
//  ViewController.swift
//  MathFarm
//
//  Created by oqbrennw on 2/23/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//


import UIKit
import AVFoundation

var audioPlayer = AVAudioPlayer()

/// ViewController for main menu
class MainMenuController: UIViewController {
    
    /// Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundmusic",ofType: "mp3")!))
            
            audioPlayer.prepareToPlay()
            
            audioPlayer.play()
            
            audioPlayer.volume = 0.8
            
        }
            
        catch{
            
            print(error)
            
        }
        

    }
    
    /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

