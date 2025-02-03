//
//  NavigationController.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 1/31/25.
//

import UIKit

class NavigationController: UINavigationController {
    var refreshItem: UIBarButtonItem = {
        var item = UIBarButtonItem()
        item.image = UIImage(systemName: "arrow.clockwise")
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshItem.target = self
        refreshItem.action = #selector(resetAction)
        topViewController?.navigationItem.setRightBarButtonItems([refreshItem], animated: false)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func resetAction() {
        StorageManager.shared.resetStorage()
    }
}
