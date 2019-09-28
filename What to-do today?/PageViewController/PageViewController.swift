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
        configurePageControl()
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
        
        
    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        print(UIScreen.main.bounds.maxY)
        print(UIDevice.modelName)
        let gap = UIDevice.modelName.contains("X") ? CGFloat(75) : CGFloat(30)
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - gap,width: UIScreen.main.bounds.width,height: gap))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
}
