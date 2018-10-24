//
//  AppDelegate.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/10/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import UIKit

import SwiftyUserDefaults
import Fabric
import Crashlytics
import ReSwift

typealias Localizable = R.string.localizable

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        WatchConnectivityService.shared.start()
        Fabric.with([Crashlytics.self])
        
        if Defaults[.wasLaunched] != true {
            
            Defaults[.wasLaunched] = true
            Defaults[.timerInterval] = 60
            Defaults[.beepInterval] = 10
        }
        
        store.dispatch(TimerAppLaunchAction(beepInterval: Defaults[.beepInterval],
                                            timeInterval: Defaults[.timerInterval]))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let nc = UINavigationController(rootViewController: MainVC())
        nc.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nc
        
        UIApplication.shared.isIdleTimerDisabled = true
        return true
    }
    
    // MARK: methods to handle timer progress after background
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        debugPrint("Foreground")
//        if store.state.roundAppState.roundState == .running {
//            // Update RoundState.progress + RoundState.roundTimeProgress
//            let endDate = store.state.roundAppState.endDate ?? Date()
//            let currentDate = Date()
//            let timeToEnd: Int = Int(ceil(endDate.timeIntervalSince(currentDate)))
//            if timeToEnd >= 1 {
//                // Update storage values
//                let interval = store.state.timerAppState.timeInterval
//                let progress: Double = 1 - (Double(timeToEnd) / Double(interval))
//                store.dispatch(RoundProgress(progress: Float(progress)))
//                store.dispatch(RoundTimeInterval(timer: Int(timeToEnd)))
//            } else {
//                // Round already finished
//                store.dispatch(RoundProgress(progress: 1.0))
//                store.dispatch(RoundTimeInterval(timer: 0))
//                store.dispatch(RoundIsOutAction(timerSecondsValue: store.state.timerAppState.timeInterval, beepValue: store.state.timerAppState.beepInterval))
//            }
//            // After update
//            store.dispatch(RoundEndDate())
//        }
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        debugPrint("Background")
//        if store.state.roundAppState.roundState == .running {
//            // Set end date
//            let endDate = Date().addingTimeInterval(TimeInterval(store.state.roundAppState.roundTimeProgress))
//            store.dispatch(RoundEndDate(endDate: endDate))
//        }
//    }
    
}


