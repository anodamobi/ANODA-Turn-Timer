//
//  AppState.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    let timerAppState: TimerAppState
}

struct TimerAppState: StateType {
    var time: TimeInterval = 0
}
