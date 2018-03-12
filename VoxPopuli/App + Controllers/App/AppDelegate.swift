//
//  AppDelegate.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupAppearance()
        setupServices()

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        ReachabilityManager.shared.stopMonitoring()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        ReachabilityManager.shared.startMonitoring()
    }
}

// MARK: - Private
private extension AppDelegate {
    
    func setupServices() {
        ReachabilityManager.shared.startMonitoring()
    }
    
    func setupWindow() {
        let networkLayer = FioLayer()
        let transactionsViewController = Storyboard.transactionsViewController()
        transactionsViewController.networkLayer = networkLayer
        let navigationController = UINavigationController(rootViewController: transactionsViewController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
    
    func setupAppearance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        
        // Navigation bar background
        navigationBarAppearance.setBackgroundImage(Theme.Images.navigationBarBackgroundImage, for: .default)
        navigationBarAppearance.isTranslucent = false
        
        // Navigation bar title color
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black, ]
        
        // Navigation bar - button title color
        navigationBarAppearance.tintColor = Theme.Colors.defaultBlue
    }
}
