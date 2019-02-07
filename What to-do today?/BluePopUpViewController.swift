//
//  BluePopUpViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class BluePopUpViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var expandBlueBox: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        backButton.backgroundColor = UIColor.clear
        expandBlueBox.layer.cornerRadius = 15
    }
    
    @IBAction func closeBluePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
