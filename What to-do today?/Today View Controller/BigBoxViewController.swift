//
//  BigBoxViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class BigBoxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandingCellDelegate, AddTableViewCellDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayBox: UIView!
    var list = [String]()
    var expandingCellHeight: CGFloat = 200
    var expandingIndexRow: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayBox.layer.cornerRadius = 10
        list.append("做project")
        list.append("看雪")
        list.append("530豆腐家吃火鍋")
        list.append("900core meeting")
        expandingIndexRow = list.count - 1
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(BigBoxViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(BigBoxViewController.keyboardWillHide),
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "addSection", for: indexPath) as!TodayAddTableViewCell
            cell.expandCellDelegate = self
            cell.addRowDelegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tuple", for: indexPath) as! TodayTupleTableViewCell
        cell.expandCellDelegate = self
        cell.textView.text = list[indexPath.row]
        return cell
    }
    
    
    func updated(height: CGFloat) {
        // expandingCellHeight = height
        print("height passed in: ", height)
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        let indexPath = IndexPath(row: expandingIndexRow, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        guard let userInfo = notification.userInfo else {return}
//        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
//        let keyBoardFrame = keyboardSize.cgRectValue
//        if self.view.frame.origin.y == 0 {
//            self.view.frame.origin.y -= keyBoardFrame.height
//        }
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y -= 0
//        }
    }
    
    func addRow(_ sender:UITableViewCell, _ newString:String) {
        list.append(newString)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: list.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
}
