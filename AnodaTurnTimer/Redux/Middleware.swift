//
//  Middleware.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift
import SwiftyUserDefaults
//#if os(watchOS)
import WatchKit
//#endif

let timerAppStateMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            switch action {
            
            case let actionState as TimerUpdateSettingsAction:
                AnalyticsHandler.logSettingsUpdates(timerValue: actionState.timeInterval,
                                                beepValue: actionState.beepInterval)
                
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
                AnalyticsHandler.logTimeIsOut(timerValue: actionState.timerSecondsValue, beepValue: actionState.beepValue)
                #if os(iOS)
                SoundManager.startEndSound()
                #elseif os(watchOS)
                WKInterfaceDevice.current().play(.success)
                #endif
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
                        #if os(iOS)
                        SoundManager.alertSound()
                        #elseif os(watchOS)
                        WKInterfaceDevice.current().play(.notification)
                        #endif
                    }
                }
            default:
                break
            }
            
            next(action)
        }
    }
}
