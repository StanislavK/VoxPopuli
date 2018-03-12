//
//  Storyboards.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case transactions = "TransactionsViewController"
    case loading = "LoadingViewController"
    case noData = "NoDataViewController"
    case noConnection = "NoConnectionViewController"
}

extension Storyboard {
    
    static func load(from storyboard: Storyboard, storyboardBundleOrNil: Bundle? = nil) -> UIViewController {
        let newStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: storyboardBundleOrNil)
        return newStoryboard.instantiateViewController(withIdentifier: storyboard.rawValue)
    }
    
    static func transactionsViewController() -> TransactionsViewController {
        guard let viewController = load(from: .transactions, storyboardBundleOrNil: nil) as? TransactionsViewController else {
            fatalError("Unable to instantiate TransactionsViewController")
        }
        
        return viewController
    }
    
    static func loadingViewController() -> LoadingViewController {
        guard let viewController = load(from: .loading, storyboardBundleOrNil: nil) as? LoadingViewController else {
            fatalError("Unable to instantiate LoadingViewController")
        }
        
        return viewController
    }

    static func noDataViewController() -> NoDataViewController {
        guard let viewController = load(from: .noData, storyboardBundleOrNil: nil) as? NoDataViewController else {
            fatalError("Unable to instantiate NoDataViewController")
        }
        
        return viewController
    }
    
    static func noConnectionViewController() -> NoConnectionViewController {
        guard let viewController = load(from: .noConnection, storyboardBundleOrNil: nil) as? NoConnectionViewController else {
            fatalError("Unable to instantiate NoConnectionViewController")
        }
    
        return viewController
    }
}
