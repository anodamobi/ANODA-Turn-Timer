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
    return AppState(timerAppState: timerReducer(action: action, state: state?.timerAppState),
                    roundAppState: roundReducer(action: action, state: state?.roundAppState))
}

func timerReducer(action: Action, state: TimerAppState?) -> TimerAppState {
    var state = state ?? TimerAppState()
    
    switch action {
        
    case let act as TimerUpdateSettings:
        state.timeInterval = act.timeInterval
        state.beepInterval = act.beepInterval
        
    case let act as TimerAppLaunchAction:
        state.beepInterval = act.beepInterval
        state.timeInterval = act.timeInterval
    default:
        break
    }
    return state
}

func roundReducer(action: Action, state: RoundState?) -> RoundState {
    var state = state ?? RoundState()
    
    switch action {
        
    case let act as RoundInitialAction:
        state.roundState = .initial
        state.progress = act.progress
        
    case let act as RoundProgress:
        state.progress = act.progress
        
    case let _ as RoundPausedAction:
        state.roundState = .paused
        
    case let _ as RoundRunningAction:
        state.roundState = .running
        
    case let act as RoundIsOutAction:
        state.beepInterval = act.beepValue
        state.roundTimeProgress = act.timerSecondsValue
        state.roundState = .isOut
    case let act as RoundTimeInterval:
        state.roundTimeProgress = act.timer
        
    default:
        break
    }
    
    return state
}
