//
//  WalkthroughViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import Gifu

class ATCClassicWalkthroughViewController: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet var imageView: GIFImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    let model: WalkthroughModel
    
    init(model: WalkthroughModel,
         nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?) {
        self.model = model
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.animate(withGIFNamed: model.icon)
        if model.icon != "Tutorial(1)" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.imageView.stopAnimatingGIF()
            }
        }
        titleLabel.text = model.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textColor = .black
        
        subtitleLabel.attributedText = NSAttributedString(string: model.subtitle)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        subtitleLabel.textColor = .black
        
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ATCClassicWalkthroughViewController.gifControl), name: NSNotification.Name(rawValue: "current index"), object: nil)
    }
    
    @objc func gifControl(_ notification: Notification) {
        var checkNum = 0
        if let num = notification.object as? NSNumber {
            checkNum = Int(truncating: num) + 1
        }
        if model.icon.contains(String(checkNum)) {
            imageView.startAnimatingGIF()
        } else {
            imageView.stopAnimatingGIF()
        }
    }
}
