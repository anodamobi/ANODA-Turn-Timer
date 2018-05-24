//
//  WatchConnectivityService.swift
//  AnodaTurnTimer
//
//  Created by Alexander Kravchenko on 5/24/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchConnectivityService: NSObject, WCSessionDelegate {
    
    static let shared = WatchConnectivityService()
    private var session: WCSession?
    
    private override init() { super.init() }
    
    func start() {
        if WCSession.isSupported() {
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
    }
    
    func updateTimeInterval(interval: TimeInterval, type: WatchConnectivityKey) {
        if let validSession = session {
            let iPhoneAppContext = [type.rawValue: interval as Double]
            
            do {
                try validSession.updateApplicationContext(iPhoneAppContext)
            } catch {
                debugPrint("Error updating Application Context: \(error)")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }
}
