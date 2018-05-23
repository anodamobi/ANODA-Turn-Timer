//
//  AppDelegate.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/10/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import UIKit

import SwiftyUserDefaults
import Fabric
import Crashlytics
import ReSwift

let store = Store<AppState>(reducer: appReducer, state: nil, middleware: [timerAppStateMiddleware, roundStateMiddleware])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])

        //update defaults
        store.dispatch(TimerAppLaunchAction(beepInterval: Defaults[.beepInterval],
                                            timeInterval: Defaults[.timerInterval],
                                            wasLaunched: Defaults[.wasLaunched]))

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let nc = UINavigationController(rootViewController: MainVC())
        nc.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nc
        
        UIApplication.shared.isIdleTimerDisabled = true
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false


        
        return true
    }
}

 
