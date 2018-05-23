//
//  AppReducers.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(timerAppState: timerReducer(action: action, state: state?.timerAppState))
}

func timerReducer(action: Action, state: TimerAppState?) -> TimerAppState {
    var state = state ?? TimerAppState()
    
    switch action {
    case let act as TimerInitialAction:
        state.time = act.timer
    case let act as TimerUpdateSettings:
        state.timeInterval = act.timeInterval
        state.beepInterval = act.beepInterval
    case let act as TimerAppLaunchAction:
        state.beepInterval = act.beepInterval
        state.timeInterval = act.timeInterval
    case let act as TimerStopAction:
        break
    case let act as TimerRunningAction:
        break
    case let act as TimerPausedActioin:
        break
    case let act as TimerIsOutAction:
        break
    default:
        break
    }
    return state
}
