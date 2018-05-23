//
//  TimerService.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/12/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import SwiftySound
import ReSwift

protocol TimerDelegate: class {
    func updated(timeInterval: Int?)
    func updated(state: TimerState)
}

class TimerService: NSObject, DataUpdated, StoreSubscriber {
    
    
    var beepValue: Int
    var timerSecondsValue: Int
    var timer = Timer()
    var seconds: Int = 0
    
    var isTimerRunning = false
    var isPaused = false
    var state: TimerState = .initial
    
    //TODO: To remove
    weak var delegate: TimerDelegate?  {
        didSet {
            updateTo(state: .initial)
        }
    }

    override init() {
        timerSecondsValue = store.state.timerAppState.timeInterval
        beepValue = store.state.timerAppState.beepInterval
        super.init()
        store.subscribe(self) { $0.select({ $0.timerAppState } ).skipRepeats({ $0.0 == $0.1 })}
    }
    
    func newState(state: TimerAppState) {
        timerSecondsValue = state.timeInterval
        beepValue = state.beepInterval
        
        updateTo(state: .initial)
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
            //TODO: Update state to isOut and check how it works.
            updateTo(state: .isOut)
            //store.dispatch(RoundIsOutAction(timerSecondsValue: timerSecondsValue, beepValue: beepValue))
        } else {
            seconds -= 1
            if seconds == beepValue {
                Sound.play(file: "alarm.mp3")
            }
            delegate?.updated(timeInterval: seconds)
        }
        let progress = CGFloat(1 - (CGFloat(seconds) / CGFloat(timerSecondsValue)))
        store.dispatch(RoundProgress(progress: progress))
    }
    
    func updateTo(state: TimerState) {
        timer.invalidate()
        
        switch state {
        case .initial: // Restart
            updateTimeInterval(timeInterval: timerSecondsValue)
//            delegate?.updated(timeInterval: timerSecondsValue)
            
        case .paused: // pause
            store.dispatch(RoundPausedAction())
        case .running: // resume if paused or started
            
            if store.state.roundState.roundState == .initial {
                updateTimeInterval(timeInterval: timerSecondsValue)
//                delegate?.updated(timeInterval: timerSecondsValue)
                Sound.play(file: "start_end.mp3")
                seconds = timerSecondsValue
            }
            runTimer()
            
        case .isOut: // time is end
            store.dispatch(RoundIsOutAction(timerSecondsValue: timerSecondsValue, beepValue: beepValue))
            store.dispatch(RoundTimeInterval(timer: 0))
            delegate?.updated(timeInterval: nil)
            Sound.play(file: "start_end.mp3")
        }
        self.state = state
        delegate?.updated(state: state)
    }
    
    func updateTimeInterval(timeInterval: Int) {
        store.dispatch(RoundTimeInterval(timer: timeInterval))
    }
    
    deinit {
        store.unsubscribe(self)
    }
}
