//
//  LevelSelectController.swift
//  MathFarm
//
//  Created by John Leland Washburn on 3/3/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit
import SpriteKit

/// ViewController for level selector
class LevelSelectController: UIViewController {


    @IBOutlet weak var CountingEasy: UIButton!
    /// Button that links to addition level
    @IBOutlet weak var AdditionBtn: UIButton!
    //button that links to pattern level
    @IBOutlet weak var PatternBtn: UIButton!
    
    @IBOutlet weak var CountingPro: UIButton!
    /// Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Transitions to GameViewController to present counting level
    ///
    /// - Parameter sender: Component that triggers function on action

    @IBAction func toCountingEasy(_ sender: UIButton) {
        performSegue(withIdentifier: "toCountingEasy", sender: self)
    }
    @IBAction func toCountingPro(_ sender: UIButton) {
        performSegue(withIdentifier: "toCountingPro", sender: self)
    }


    @IBAction func toAdditionEasy(_ sender: UIButton) {
        performSegue(withIdentifier: "toEasyAddition", sender: self)
    }
    
    @IBAction func toAdditionMedium(_ sender: UIButton) {
        performSegue(withIdentifier: "toMediumAddition", sender: self)
    }
    
    
    @IBAction func toAdditionHard(_ sender: UIButton) {
        performSegue(withIdentifier: "toHardAddition", sender: self)
    }
    
    @IBAction func backToStartPage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameViewController
        if(segue.identifier == "toCountingEasy") {
            vc.gameType = "countingEasy"
        } else if (segue.identifier=="toCountingPro"){
            vc.gameType = "countingPro"
        }
        else if(segue.identifier=="toEasyAddition") {
            vc.gameType = "addition"
        }
        else if(segue.identifier=="toMediumAddition") {
            vc.gameType = "MedAddition"
        }
        else if(segue.identifier=="toHardAddition") {
            vc.gameType = "AdvAddition"
        }
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
