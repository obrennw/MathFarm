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

    /// Button that links to couting level
    @IBOutlet weak var CountingBtn: UIButton!
    /// Button that links to addition level
    @IBOutlet weak var AdditionBtn: UIButton!
    //button that links to pattern level
    @IBOutlet weak var PatternBtn: UIButton!
    
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
    @IBAction func toCountingLevel(_ sender: UIButton) {
        performSegue(withIdentifier: "toCounting", sender: self)
    }
    
    @IBAction func toAdditionLevel(_ sender: UIButton) {
        performSegue(withIdentifier: "toSubLvlSelection", sender: self)
    }
    @IBAction func backToStartPage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="toCounting") {
            print("here")
            let vc = segue.destination as! GameViewController
            vc.gameType = "counting"
        }
        else if(segue.identifier=="toSubLvlSelection") {
            let vc = segue.destination as! SubLevelSelectController
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
