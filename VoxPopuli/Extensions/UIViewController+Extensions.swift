//
//  UIViewController+Extensions.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import UIKit

extension UIViewController {
 
    /// Add child view controller
    func addChildViewControllerToParentSelf(child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    /// Remove child view controller
    func removeChildViewControllerFromParentSelf() {
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
    
    /// Show simple alert
    func showAlert(with title: String, message: String, cancelButtonText: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: cancelButtonText, style: .cancel, handler: nil))
        
        present(controller, animated: true, completion: nil)
    }
}
