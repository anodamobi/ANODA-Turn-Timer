//
//  AppActions.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift
import protocol ReSwift.Action

struct TimerAppLaunchAction: Action {
    var beepInterval: Int
    var timeInterval: Int
}

struct TimerUpdateSettingsAction: Action {
    var timeInterval: Int
    var beepInterval: Int
}

struct RoundRunningAction: Action {}
struct RoundPausedAction: Action {}
struct RoundReplayAction: Action {
    var timeValue: Int
    var beepValue: Int
}

struct RoundIsOutAction: Action {
    var timerSecondsValue: Int
    var beepValue: Int
}

struct RoundProgress: Action { var progress: Double }
struct RoundTimeInterval: Action { var timer: Int }

struct RoundEndDate: Action { var endDate: Date? }
struct RoundInitialAction: Action {
    var progress: Double
}
