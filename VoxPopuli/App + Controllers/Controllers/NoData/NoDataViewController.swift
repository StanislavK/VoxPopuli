//
//  NoDataViewController.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import UIKit

final class NoDataViewController: UIViewController {
    
    var reloadDataHandler: (() -> Void)?
    
    // MARK: - IB Outlets
    
    @IBAction func reloadData(_ sender: Button) {
        reloadDataHandler?()
    }
}
