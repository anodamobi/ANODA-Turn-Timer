//
//  Middleware.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift
import Crashlytics
import SwiftyUserDefaults

let logOnOutMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            switch action {
            case let actionState as TimerInitialAction:
                break
            case let actionState as TimerIsOutAction:
                Answers.logCustomEvent(withName: "Time is out",
                                       customAttributes: ["Total": actionState.timerSecondsValue, "Beep": actionState.beepValue])
            case let actionState as TimerAppLaunchAction:
                if actionState.wasLaunched != true {
                    
                    Defaults[.wasLaunched] = true
                    Defaults[.timerInterval] = 60
                    Defaults[.beepInterval] = 10
                }
            case let actionState as TimerUpdateSettings:
                
                Answers.logCustomEvent(withName: "Settings updated",
                                       customAttributes: ["Total": actionState.timeInterval,
                                                          "Beep": actionState.beepInterval])
                
                Defaults[.timerInterval] = actionState.timeInterval
                Defaults[.beepInterval] = actionState.beepInterval
                
            default:
                break
            }

            next(action)
        }
    }
}
