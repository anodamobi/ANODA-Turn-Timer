//
//  AppState.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift

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
    var time: TimeInterval = 0
    var beepInterval: Int = 0
    var timeInterval: Int = 0
    
    static func == (lhs: TimerAppState, rhs: TimerAppState) -> Bool {
        return lhs.time == rhs.time &&
        lhs.beepInterval == rhs.beepInterval &&
        lhs.timeInterval == rhs.timeInterval
    }
}

struct RoundState: StateType {
    var progress: CGFloat = 0.0
    var roundState: TimerState = .initial
    
    var beepInterval: Int = 0
    var roundTimeProgress: Int = 0
    
    static func == (lhs: RoundState, rhs: RoundState) -> Bool {
        return lhs.roundState == rhs.roundState &&
            lhs.roundTimeProgress == rhs.roundTimeProgress &&
            lhs.beepInterval == rhs.beepInterval &&
            lhs.progress == rhs.progress
    }
}
