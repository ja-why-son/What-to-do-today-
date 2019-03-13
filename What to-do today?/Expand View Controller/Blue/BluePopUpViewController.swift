//
//  BluePopUpViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class BluePopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandingCellDelegate, AddTableViewCellDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var expandBlueBox: UIView!
    @IBOutlet weak var tableView: UITableView!
    var list = [String]()
    var expandingCellHeight: CGFloat = 200
    var expandingIndexRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        backButton.backgroundColor = UIColor.clear
        expandBlueBox.layer.cornerRadius = 15
        self.showAnimate()
        list.append("make expansion for each of the small box")
        expandingIndexRow = list.count - 1
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(OrangePopUpViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(OrangePopUpViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    // this method is called multiple times whenever a certain indexPath is asking for a data, therefore, assign "" for index 'list.count'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == list.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addSection", for: indexPath) as! BlueAddTableViewCell
            cell.expandCellDelegate = self
            cell.addRowDelegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tuple", for: indexPath) as! BlueTupleTableViewCell
        cell.expandCellDelegate = self
        cell.textView.text = list[indexPath.row]
        return cell
    }
    
    func updated(height: CGFloat) {
        expandingCellHeight = height
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        let indexPath = IndexPath(row: expandingIndexRow, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
   func addRow(_ sender:UITableViewCell, _ newString:String) {
    list.append(newString)
    tableView.beginUpdates()
    tableView.insertRows(at: [IndexPath(row: list.count - 1, section: 0)], with: .automatic)
    tableView.endUpdates()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // implement here?
    }
    
    @IBAction func closeBluePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion: {(finished : Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
}
