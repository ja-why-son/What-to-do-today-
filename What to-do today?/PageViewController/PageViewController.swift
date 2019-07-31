//
//  ToDoViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/1/25.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class ToDoViewController: UIPageViewController, UIScrollViewDelegate{

    var currentPage : Int = 0
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(name: "AllToDoViewController"),
                self.newViewController(name: "TodayToDoViewController")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                break;
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoViewController.enableSwipe), name:NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoViewController.disableSwipe), name:NSNotification.Name(rawValue: "disableSwipe"), object: nil)
    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
}
