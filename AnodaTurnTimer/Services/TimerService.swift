//
//  TimerService.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/12/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import SwiftySound

enum TimerState {
    case initial
    case running
    case paused
    case isOut
}

protocol TimerDelegate: class {
    func updated(timeInterval: Int?)
    func updated(state: TimerState)
    func updated(progress: CGFloat)
}

class TimerService: NSObject, DataUpdated {
    
    var beepValue: Int
    var timerSecondsValue: Int
    var timer = Timer()
    var seconds: Int = 0
    
    var isTimerRunning = false
    var isPaused = false
    var state: TimerState = .initial
    
    weak var delegate: TimerDelegate? {
        didSet {
            updateTo(state: .initial)
        }
    }

    override init() {
        timerSecondsValue = Defaults[.timerInterval]
        beepValue = Defaults[.beepInterval]
    }

    func loadData() {

        let isChangedSeconds = timerSecondsValue != Defaults[.timerInterval]
        let isChangedBeep = beepValue != Defaults[.beepInterval]
        
        timerSecondsValue = Defaults[.timerInterval]
        beepValue = Defaults[.beepInterval]

        if isChangedBeep || isChangedSeconds {
            updateTo(state: .initial)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(updateTimer)),
                                     userInfo: nil,
                                     repeats: true)
    }

    func updateTimer() {
        if seconds < 1 {
            updateTo(state: .isOut)
        } else {
            seconds -= 1
            if seconds == beepValue {
                Sound.play(file: "alarm.mp3")
            }
            delegate?.updated(timeInterval: seconds)
        }
        let progress = CGFloat(1 - (CGFloat(seconds) / CGFloat(timerSecondsValue)))
        delegate?.updated(progress: progress)
    }
    
    func updateTo(state: TimerState) {
        timer.invalidate()
        
        switch state {
        case .initial: // Restart
            delegate?.updated(timeInterval: timerSecondsValue)
            
        case .paused: // pause
            delegate?.updated(state: .paused)
        case .running: // resume if paused or started
            
            if self.state == .initial {
                delegate?.updated(timeInterval: timerSecondsValue)
                Sound.play(file: "start_end.mp3")
                seconds = timerSecondsValue
            }
            runTimer()
        case .isOut: // time is end
            delegate?.updated(timeInterval: nil)
            Sound.play(file: "start_end.mp3")
        }
        self.state = state
        delegate?.updated(state: state)
    }
}
