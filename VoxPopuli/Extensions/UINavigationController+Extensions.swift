//
//  UINavigationController+Extensions.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    // Status bar style
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topViewController = self.topViewController {
            return topViewController.preferredStatusBarStyle
        } else {
            return .lightContent
        }
    }
    
    // Rotation
    open override var shouldAutorotate: Bool {
        return self.visibleViewController?.shouldAutorotate ?? true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations ?? .all
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.visibleViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
