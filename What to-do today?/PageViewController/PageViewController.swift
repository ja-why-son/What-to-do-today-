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
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoViewController.enableSwipe), name:NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoViewController.disableSwipe), name:NSNotification.Name(rawValue: "disableSwipe"), object: nil)
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
        self.delegate = self
        configurePageControl()
        
    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 75,width: UIScreen.main.bounds.width,height: 75))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
}
