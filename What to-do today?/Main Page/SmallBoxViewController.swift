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
    
    
    @IBAction func showBox (_ sender :  Any) {
        print(sender)
        var senderTag : Int = -1
        var popUp : UIViewController? = nil
        var category : String? = nil
        
        print(type(of: sender))
        let gesture = sender as? UITapGestureRecognizer
        print(gesture?.view?.tag)
        senderTag = (gesture?.view!.tag)!
        
        switch senderTag {
            case 0: // do red
                category = "RedPopUp"
                popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: category!) as! RedPopUpViewController
            case 1:  // do orange
                category = "OrangePopUp"
                popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: category!) as! OrangePopUpViewController
            case 2:  // do blue
                category = "BluePopUp"
                popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: category!) as! BluePopUpViewController
            case 3:  // do green
                category = "GreenPopUp"
                popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: category!) as! GreenPopUpViewController


            default: return // do last one
        }
        
        self.addChild(popUp!)
        popUp!.view.frame = self.view.frame
        self.view.addSubview(popUp!.view)
        popUp!.didMove(toParent: self)
    }
}
