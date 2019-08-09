//
//  BigBoxViewController + Drag.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/8.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension BigBoxViewController : UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        print("HI")
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        Constants.mediumHaptic.impactOccurred()
        let todoItem = list[indexPath.row]
        let itemProvider = NSItemProvider(object: todoItem)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        return[dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        
        let estilo = UIDragPreviewParameters()
        estilo.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9568627451, blue: 0.6470588235, alpha: 1)
        return estilo
    }
    
}
