//
//  PopUpViewController + Drag.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension PopUpViewController : UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row == list.count || isMakingEdit {
            return []
        }
        Constants.mediumHaptic.impactOccurred()
        let todoItem = list[indexPath.row]
        let itemProvider = NSItemProvider(object: todoItem)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return[dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let estilo = UIDragPreviewParameters()
        estilo.backgroundColor = color
        return estilo
    }
}
