//
//  LevelSelectController.swift
//  test2
//
//  Created by John Leland Washburn on 3/3/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

class LevelSelectController: UIViewController {

    @IBOutlet weak var CountingBtn: UIButton!
    
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
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController1") as! GameViewController
        self.present(viewController, animated: true, completion: nil)
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
