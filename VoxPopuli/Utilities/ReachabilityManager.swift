//
//  ReachabilityManager.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import Reachability

/// Protocol for listenig network status changes
public protocol NetworkConnectionStatusListener : class {
    func networkConnectionStatusDidChange(connection: Reachability.Connection)
}

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    // Private init to disable instantiating
    private override init() {
        super.init()
    }
    
    // Reachability instance for status monitoring
    private let reachability = Reachability()!
    
    var connection: Reachability.Connection {
        return reachability.connection
    }
    
    var isConnected : Bool {
        return reachability.connection != .none
    }
    
    // Array of delegates which are interested to listen to network status changes
    var listeners = [NetworkConnectionStatusListener]()
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(notification: )),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do {
            try reachability.startNotifier()
            print("Start monitoring reachability")
        } catch {
            print("Could not start reachability notifier!")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring() {
        print("Stop monitoring reachability")
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    
    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    func addListener(listener: NetworkConnectionStatusListener) {
        listeners.append(listener)
        print("Listener added.")
    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func removeListener(listener: NetworkConnectionStatusListener) {
        listeners = listeners.filter{ $0 !== listener}
        print("Listener removed.")
    }
}

extension ReachabilityManager {
    
    /// Called whenever there is a change in reachability status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkConnectionStatusDidChange(connection: reachability.connection)
        }
    }
}
