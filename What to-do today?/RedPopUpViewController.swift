//
//  RedPopUpViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class RedPopUpViewController: UIViewController {

    
    
    @IBOutlet weak var expandRedBox: UIView!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        backButton.backgroundColor = UIColor.clear
        expandRedBox.layer.cornerRadius = 15
    }
    
    
    @IBAction func closeRedPopUp(_ sender: Any) {
        self.view.removeFromSuperview()

    }
    
    

}
