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
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: name)
    }
    
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
    
}

extension ToDoViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    @objc func disableSwipe(){
        self.dataSource = nil
    }
    
    @objc func enableSwipe(){
        self.dataSource = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        currentPage = viewControllerIndex
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        currentPage = viewControllerIndex
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        guard let viewControllerIndex = orderedViewControllers.index(of: pageViewController.viewControllers!.first!) else {return}
//        print(viewControllerIndex)
//        print("HI")
//    }
//
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("end animation")
//    }
//
//
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return currentPage
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) || (currentPage == 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
//            print("\(currentPage) is current page");
//            print("content offset is \(scrollView.contentOffset.x)")
//            print("bound size is \(scrollView.bounds.size.width)")
//            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
//        }
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if (currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
//            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
//            print(scrollView.bounds.size.width)
//        } else if (currentPage == 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
//            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
//            print(scrollView.bounds.size.width)
//
//        }
//    }

}


