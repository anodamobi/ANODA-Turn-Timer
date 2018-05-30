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
            
            case let actionState as TimerUpdateSettings:
                AnalyticsHandler.logSettingsUpdates(timerValue: actionState.timeInterval,
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
                AnalyticsHandler.logTimeIsOut(timerValue: actionState.timerSecondsValue, beepValue: actionState.beepValue)
                SoundManager.startEndSound()
            case let actionState as RoundInitialAction:
                break
            case let actionState as RoundRunningAction:
                break
            case let actionState as RoundPausedAction:
                break
            case let actionState as RoundReplayAction:
                AnalyticsHandler.logTimeRestart(timerValue: actionState.timeValue, beepValue: actionState.beepValue)
            case let actionState as RoundTimeInterval:
                if actionState.timer == Defaults[.beepInterval] {
                    if actionState.timer > 0 {
                        SoundManager.alertSound()
                    }
                }
            default:
                break
            }
            
            next(action)
        }
    }
}
