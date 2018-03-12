//
//  LoadingViewController.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.startAnimating()
    }
}
