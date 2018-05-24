//
//  MainController+Session.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/24/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

extension MainController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if startButtonState == .start || startButtonState == .restart {
            DispatchQueue.main.async { [unowned self] in
                self.processAppContext()
            }
        }
    }
    
    func processAppContext() {
        if let iPhoneContext = session.receivedApplicationContext as? [String : Double] {
            
            if let interval = iPhoneContext[WatchConnectivityKey.roundDuration.rawValue] {
                timerService.choosenInterval = interval
                updateTimerLabel()
            }
            
            if let interval = iPhoneContext[WatchConnectivityKey.beepInterval.rawValue] {
                timerService.beepInterval = interval
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}

