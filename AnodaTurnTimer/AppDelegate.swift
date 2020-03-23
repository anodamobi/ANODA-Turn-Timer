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
        
}


