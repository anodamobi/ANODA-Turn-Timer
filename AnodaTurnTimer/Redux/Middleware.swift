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

let timerAppStateMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            switch action {
                
            case var actionState as TimerAppLaunchAction:
                if actionState.wasLaunched != true {
                    
                    Defaults[.wasLaunched] = true
                    Defaults[.timerInterval] = 60
                    Defaults[.beepInterval] = 10
                }
                actionState.timeInterval = Defaults[.timerInterval]
                actionState.beepInterval = Defaults[.beepInterval]
                next(actionState)
                break
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

let roundStateMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            switch action {
            case let actionState as RoundIsOutAction:
                Answers.logCustomEvent(withName: "Time is out",
                                       customAttributes: ["Total": actionState.timerSecondsValue, "Beep": actionState.beepValue])
            case let actionState as RoundInitialAction:
                break
            case let actionState as RoundRunningAction:
                break
            case let actionState as RoundPausedAction:
                break
            case let actionState as RoundReplayAction:
                break
            default:
                break
            }
            
            next(action)
        }
    }
}
