//
//  MainController+Session.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/24/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

extension MainController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [unowned self] in
            self.processAppContext()
        }
    }
    
    func processAppContext() {
        if let iPhoneContext = session.receivedApplicationContext as? [String : Double] {
            
            if let interval = iPhoneContext[WatchConnectivityKey.roundDuration.rawValue] {
                let beepInterval = store.state.timerAppState.beepInterval
                store.dispatch(TimerUpdateSettingsAction(timeInterval: Int(interval),
                                                         beepInterval: beepInterval))
            }
            
            if let interval = iPhoneContext[WatchConnectivityKey.beepInterval.rawValue] {
                let timeInterval = store.state.timerAppState.timeInterval
                store.dispatch(TimerUpdateSettingsAction(timeInterval: timeInterval,
                                                         beepInterval: Int(interval)))
            }
            
            let state = store.state.roundAppState.roundState
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}

