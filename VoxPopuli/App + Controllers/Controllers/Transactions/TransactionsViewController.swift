//
//  TransactionsViewController.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import UIKit
import Reachability

final class TransactionsViewController: UIViewController {
    
    var networkLayer: NetworkLayer?
    
    fileprivate var noConnectionViewController: NoConnectionViewController?
    fileprivate var noDataViewController: NoDataViewController?
    fileprivate var loadingViewController: LoadingViewController?
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Theme.Colors.lightBlack
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        return refreshControl
    }()

    fileprivate var transactions: [Transaction] = [] {
        didSet {
            if transactions.count == 0 {
                showNoDataViewController()
            } else {
                hideNoDataViewControler()
                tableView.reloadData()
            }
        }
    }
    // MARK: - IB Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservers()
        setupView()
        transactions = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ReachabilityManager.shared.addListener(listener: self)
        print("Adding Reachability listener from TransactionsViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ReachabilityManager.shared.removeListener(listener: self)
        print("Removing Reachability listener from TransactionsViewController")
    }
    
    func setupView() {
        navigationItem.title = "Vox Populi"
        
        // Back button only, no text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        // setup tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionsTableViewCell.nib, forCellReuseIdentifier: TransactionsTableViewCell.identifier)
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 300
        tableView.separatorStyle = .none
    }
    
    @objc func reloadData() {
        refreshControl.beginRefreshing()
        loadData()
    }
    
    func loadData() {
        guard ReachabilityManager.shared.isConnected else { return }
        print("Loading data/transactions")
        
        networkLayer?.fetchTransactions(completionHandler: { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.refreshControl.endRefreshing()
            
            switch result {
            case .success(let fetchedTransactions):
                strongSelf.transactions = fetchedTransactions
            case .failure(let error):
                guard let error = error else {
                    //strongSelf.showAlert(message: "Unknown error, please retry")
                    return
                }
                strongSelf.showAlert(with: "Error", message: error.localizedDescription, cancelButtonText: "OK")
            }
        })
    }
    
    func perfromActionsWhenReachabilityChanged() {
        let isConnected = ReachabilityManager.shared.isConnected
        switch isConnected {
        case true:
            print("Is connected")
            hideNoConnectionViewControler()
            tableView.refreshControl = refreshControl
        case false:
            print("No connection")
            showNoConnectionViewController()
            tableView.refreshControl = nil
        }
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appNotificationObserved(notification:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    @objc func appNotificationObserved(notification: NSNotification) {
        switch notification.name {
        case NSNotification.Name.UIApplicationDidBecomeActive:
            // Make sure you are in TransactionsViewController
            guard navigationController?.topViewController === self else { return }
        //loadData() // TODO: WIP:Refactor this here. Commented out to see NoDataViewController in action.
        default: break
        }
    }
    
    // TODO: Refactor hiding and showing view controllers
    func hideNoConnectionViewControler() {
        noConnectionViewController?.removeChildViewControllerFromParentSelf()
        noConnectionViewController = nil
    }
    
    func showNoConnectionViewController() {
        let noConnectionController = Storyboard.noConnectionViewController()
        addChildViewControllerToParentSelf(child: noConnectionController)
        noConnectionViewController = noConnectionController
    }
    
    func hideNoDataViewControler() {
        noDataViewController?.removeChildViewControllerFromParentSelf()
        noDataViewController = nil
    }
    
    func showNoDataViewController() {
        let noDataController = Storyboard.noDataViewController()
        addChildViewControllerToParentSelf(child: noDataController)
        noDataViewController = noDataController
        noDataViewController?.reloadDataHandler = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.reloadData()
        }
    }
    
    func hideLoadingViewControler() {
        loadingViewController?.removeChildViewControllerFromParentSelf()
        loadingViewController = nil
    }
    
    func showLoadingViewController() {
        let loadingController = Storyboard.loadingViewController()
        addChildViewControllerToParentSelf(child: loadingController)
        loadingViewController = loadingController
    }
}

// MARK: - <UITableViewDelegate>
extension TransactionsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - <UITableViewDataSource>
extension TransactionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsTableViewCell.identifier, for: indexPath) as! TransactionsTableViewCell
        cell.model = TransactionViewModel(transactions[indexPath.row])
        return cell
    }
}

// MARK: - <NetworkStatusListener>
extension TransactionsViewController: NetworkConnectionStatusListener {
    
    func networkConnectionStatusDidChange(connection: Reachability.Connection) {
        switch connection {
        case .none:
            print("[TransactionsViewController] - Network became unreachable")
        case .wifi:
            print("[TransactionsViewController] - Network reachable through WiFi")
        case .cellular:
            print("[TransactionsViewController] - Network reachable through Cellular Data")
        }
        
        // Do the following below when networking status is changed.
        perfromActionsWhenReachabilityChanged()
    }
}
