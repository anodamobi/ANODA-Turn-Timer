//
//  AppState.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift

let store = Store<AppState>(reducer: appReducer, state: nil, middleware: [timerAppStateMiddleware, roundStateMiddleware])

enum TimerState {
    case initial
    case running
    case paused
    case isOut
}

struct AppState: StateType {
    let timerAppState: TimerAppState
    let roundAppState: RoundState
}

struct TimerAppState: StateType {
    var beepInterval: Int = 0
    var timeInterval: Int = 0
    
    static func == (lhs: TimerAppState, rhs: TimerAppState) -> Bool {
        return lhs.beepInterval == rhs.beepInterval &&
        lhs.timeInterval == rhs.timeInterval
    }
}

struct RoundState: StateType {
    var progress: Float = 0.0 // Percentage (time left to end) (max value = 1.0)
    var roundState: TimerState = .initial
    
    var beepInterval: Int = 0
    var roundTimeProgress: Int = 0 // Time to round end
    
    // Set while app goes to background, nil after update in foreground
    // DO NOT USE start date because of timer pause
    var endDate: Date?
    
    static func == (lhs: RoundState, rhs: RoundState) -> Bool {
        return lhs.roundState == rhs.roundState &&
            lhs.roundTimeProgress == rhs.roundTimeProgress &&
            lhs.beepInterval == rhs.beepInterval &&
            lhs.progress == rhs.progress &&
            lhs.endDate == rhs.endDate
    }
}
