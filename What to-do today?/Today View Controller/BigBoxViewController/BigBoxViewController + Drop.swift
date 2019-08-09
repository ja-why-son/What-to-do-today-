//
//  BigBoxViewController + Drop.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/8.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension BigBoxViewController : UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        // The .move operation is available only for dragging within a single app.
        
        if let _ = destinationIndexPath {
            if destinationIndexPath!.row >= todayList.count {
                return UITableViewDropProposal(operation: .cancel)
            }
        } else {
            return UITableViewDropProposal(operation: .cancel)
        }
        
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                if destinationIndexPath?.row != dropTarget {
                    Constants.mediumHaptic.impactOccurred()
                    dropTarget = destinationIndexPath!.row
                }
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: Todo.self)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let estilo = UIDragPreviewParameters()
        estilo.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9568627451, blue: 0.6470588235, alpha: 1)
        return estilo
    }
}
