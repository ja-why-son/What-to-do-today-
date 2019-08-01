//
//  PopUpViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class PopUpViewController: UIViewController{
 
    
    // UI Components
    @IBOutlet weak var expandBox: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UITextField!
    
    // Variables
    var user : User? = nil
    var list = [Todo]()
    var indexList = [Int]()
    var expandingCellHeight: CGFloat = 200
    var color : UIColor? = nil
    var category : String? = nil
    var delegate : SmallBoxPopUpDelegate?
    var categoryName : String? = nil
    var labelTag : Int?
    var scrollTarget : IndexPath?
    var labelEdit : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // STYLING
        label.tag = labelTag!
        label.text = categoryName
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        backButton.backgroundColor = UIColor.clear
        expandBox.layer.cornerRadius = 15
        expandBox.backgroundColor = color
        self.showAnimate()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        //Misc
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PopUpViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(PopUpViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(PopUpViewController.editLabel), name:NSNotification.Name(rawValue: "label is editting"), object: nil)
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        scrollTarget = IndexPath(row: 0, section: 0)
        labelEdit = false
    }
    
    @objc func editLabel () {
        labelEdit = true
    }
 
}
