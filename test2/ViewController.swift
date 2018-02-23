//
//  ViewController.swift
//  test2
//
//  Created by oqbrennw on 2/23/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//


//let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController1") as! GameViewController
//self.present(viewController, animated: true, completion: nil)
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClick(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController1") as! GameViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
   
    

}

