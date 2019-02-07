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
    
    @IBAction func showRedPopUp(_ sender: Any) {
        let redPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RedPopUp") as! RedPopUpViewController
        self.addChild(redPopUp)
        redPopUp.view.frame = self.view.frame
        self.view.addSubview(redPopUp.view)
        redPopUp.didMove(toParent: self)
        
    }
    
    
    @IBAction func showOrangeBox(_ sender: Any) {
        let orangePopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrangePopUp") as! OrangePopUpViewController
        self.addChild(orangePopUp)
        orangePopUp.view.frame = self.view.frame
        self.view.addSubview(orangePopUp.view)
        orangePopUp.didMove(toParent: self)
    }
    
    @IBAction func showBlueBox(_ sender: Any) {
        let bluePopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BluePopUp") as! BluePopUpViewController
        self.addChild(bluePopUp)
        bluePopUp.view.frame = self.view.frame
        self.view.addSubview(bluePopUp.view)
        bluePopUp.didMove(toParent: self)
    }
    
    @IBAction func showGreenBox(_ sender: Any) {
        let greenPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GreenPopUp") as! GreenPopUpViewController
        self.addChild(greenPopUp)
        greenPopUp.view.frame = self.view.frame
        self.view.addSubview(greenPopUp.view)
        greenPopUp.didMove(toParent: self)
    }
    
    
}
