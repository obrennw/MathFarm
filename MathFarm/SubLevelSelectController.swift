//
//  SubLevelSelectController.swift
//  MathFarm
//
//  Created by Mian Xing on 4/19/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

class SubLevelSelectController: UIViewController {
    
    @IBOutlet weak var toEasyLvl: UIButton!
    @IBOutlet weak var toHardLvl: UIButton!
    @IBOutlet weak var toMedLvl: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toEasyAddi(_ sender: UIButton) {
        performSegue(withIdentifier: "toEasyAddition", sender: self)
    }
    
    @IBAction func toHardAddi(_ sender: UIButton) {
        performSegue(withIdentifier: "toHardAddition", sender: self)
    }
    
    @IBAction func toMedAddi(_ sender: UIButton) {
        performSegue(withIdentifier: "toMediumAddition", sender: self)
    }
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier != "backToUpperLevel") {
            let vc = segue.destination as! GameViewController
            switch segue.identifier {
            case "toEasyAddition"?:
                vc.gameType = "addition"
            case "toMediumAddition"?:
                vc.gameType = "MedAddition"
            case "toHardAddition"?:
                vc.gameType = "AdvAddition"
            default: break
            }
//            if(segue.identifier=="toEasyAddition") {
//                vc.gameType = "addition"
//            }
//            else if(segue.identifier=="toHardAddition") {
//                vc.gameType = "AdvAddition"
//            }
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
