//
//  BigBoxViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class BigBoxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandingCellDelegate {

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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tuple", for: indexPath) as! TodayTupleTableViewCell
        cell.delegate = self
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
    
}
