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
                EventHandler.logSettingsUpdates(timerValue: actionState.timeInterval,
                                                beepValue: actionState.beepInterval)
                
                Defaults[.timerInterval] = actionState.timeInterval
                Defaults[.beepInterval] = actionState.beepInterval
                
                actionState.settingsVC.navigationController?.popViewController(animated: true)
                
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
                EventHandler.logTimeIsOut(timerValue: actionState.timerSecondsValue, beepValue: actionState.beepValue)
                SoundManager.startEndSound()
            case let actionState as RoundInitialAction:
                break
            case let actionState as RoundRunningAction:
                break
            case let actionState as RoundPausedAction:
                break
            case let actionState as RoundReplayAction:
                EventHandler.logTimeRestart(timerValue: actionState.timeValue, beepValue: actionState.beepValue)
            case let actionState as RoundTimeInterval:
                if actionState.timer == Defaults[.beepInterval] {
                    SoundManager.alertSound()
                }
            default:
                break
            }
            
            next(action)
        }
    }
}
