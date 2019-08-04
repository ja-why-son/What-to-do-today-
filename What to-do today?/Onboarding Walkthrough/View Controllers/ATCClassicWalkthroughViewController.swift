//
//  WalkthroughViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class ATCClassicWalkthroughViewController: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet var imageView: UIImageView!
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
//        imageView.image = UIImage.localImage(model.icon, template: true)
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.tintColor = .white
//        imageContainerView.backgroundColor = .clear
        
        titleLabel.text = model.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textColor = .white
        
        subtitleLabel.attributedText = NSAttributedString(string: model.subtitle)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        subtitleLabel.textColor = .white
        
        containerView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
}
