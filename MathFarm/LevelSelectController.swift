//
//  LevelSelectController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 3/3/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

/// ViewController for level selector
class LevelSelectController: UIViewController {


    /// Counting Easy Button reference
    @IBOutlet weak var CountingEasy: UIButton!
    /// Addition Easy button reference
    @IBOutlet weak var AdditionBtn: UIButton!
    /// Counting Pro button reference
    @IBOutlet weak var CountingPro: UIButton!
    
    /// AudioPlayer object for MathFarm theme music
    var audioPlayer: AVAudioPlayer? = nil
    
    /// Called on view loading
    override func viewDidLoad() {
        super.viewDidLoad()
        print("new load")
    }

    /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Transitions to GameViewController to present counting level
    ///
    /// - Parameter sender: Component that triggers function on action

    /// Segue to CountingScene (Easy difficulty) instance
    ///
    /// - Parameter sender: Counting Easy UIButton that triggers event
    @IBAction func toCountingEasy(_ sender: UIButton) {
        performSegue(withIdentifier: "toCountingEasy", sender: self)
    }
    /// Segue to CountingScene (Pro difficulty) instance
    ///
    /// - Parameter sender: Counting Pro UIButton that triggers event
    @IBAction func toCountingPro(_ sender: UIButton) {
        performSegue(withIdentifier: "toCountingPro", sender: self)
    }


    /// Segue to EasyAdditionScene instance
    ///
    /// - Parameter sender: Addition Easy UIButton that triggers event
    @IBAction func toAdditionEasy(_ sender: UIButton) {
        performSegue(withIdentifier: "toEasyAddition", sender: self)
    }
    
    /// Segue to MedAdditionScene instance
    ///
    /// - Parameter sender: Addition Medium UIButton that triggers event
    @IBAction func toAdditionMedium(_ sender: UIButton) {
        performSegue(withIdentifier: "toMediumAddition", sender: self)
    }
    
    
    /// Segue to AdvAdditionScene instance
    ///
    /// - Parameter sender: Addition Pro UIButton that triggers event
    @IBAction func toAdditionHard(_ sender: UIButton) {
        performSegue(withIdentifier: "toHardAddition", sender: self)
    }
    
    @IBAction func backToStartPage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Sets the game type of the GameViewController recieving the segue according to the segue identifier.
    ///
    /// - Parameters:
    ///   - segue: the segue being sent fromt the view
    ///   - sender: object that sends the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toCountingEasy") {
            let vc = segue.destination as! GameViewController
            vc.gameType = "countingEasy"
        } else if (segue.identifier=="toCountingPro"){
            let vc = segue.destination as! GameViewController
            vc.gameType = "countingPro"
        }
        else if(segue.identifier=="toEasyAddition") {
            let vc = segue.destination as! GameViewController
            vc.gameType = "addition"
        }
        else if(segue.identifier=="toMediumAddition") {
            let vc = segue.destination as! GameViewController
            vc.gameType = "MedAddition"
        }
        else if(segue.identifier=="toHardAddition") {
            let vc = segue.destination as! GameViewController
            vc.gameType = "AdvAddition"
        }
    }
    
    /// Toggles MathFarm theme music off/on
    ///
    /// - Parameter sender: Toggle Music UIButton
    @IBAction func toggleMusic(_ sender: UIButton) {
        if(audioPlayer == nil){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundmusic",ofType: "mp3")!))
                audioPlayer?.prepareToPlay()
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
                audioPlayer?.volume = 2.0
            }
                
            catch{
                print(error)
            }
        } else{
            if (audioPlayer?.isPlaying)!{
                audioPlayer?.stop()
            } else{
                audioPlayer?.play()
            }
        }
    }
}


