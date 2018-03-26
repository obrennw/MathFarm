//
//  LevelSelectController.swift
//  test2
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
        let viewController:GameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController1") as! GameViewController
        viewController.gameType = "counting"
        self.present(viewController, animated: true, completion: nil)

        
    }
    
    @IBAction func toAdditionLevel(_ sender: UIButton) {
        let viewController:GameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController1") as! GameViewController
        viewController.gameType = "addition"
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    override var shouldAutorotate: Bool {
        return false
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
