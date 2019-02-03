//
//  SmallBoxViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/2.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class SmallBoxViewController: UIViewController {

    @IBOutlet weak var redBox: UIView!
    @IBOutlet weak var orangeBox: UIView!
    @IBOutlet weak var blueBox: UIView!
    @IBOutlet weak var greenBox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redBox.layer.cornerRadius = 10
        orangeBox.layer.cornerRadius = 10
        blueBox.layer.cornerRadius = 10
        greenBox.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
