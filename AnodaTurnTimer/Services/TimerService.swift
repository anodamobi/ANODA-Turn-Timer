//
//  TimerService.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/12/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import SwiftySound
import ReSwift

class TimerService: NSObject {

    var beepValue: Int = 0
    var timerSecondsValue: Int = 0
    var timer = Timer()
    var seconds: Int = 0
    
    var state: TimerState = .initial
    
    private var timerAppState: ReduxHelper<TimerAppState>?
    
    private var roundAppState: ReduxHelper<RoundState>?


    override init() { 
        super.init()
        timerSecondsValue = store.state.timerAppState.timeInterval
        beepValue = store.state.timerAppState.beepInterval
        setupSubscription()

    }
    
    func setupSubscription() {
        
        timerAppState = ReduxHelper<TimerAppState>.init({ (subscriber) in
                store.subscribe(subscriber) { $0.select({ $0.timerAppState } ).skipRepeats({ $0.0 == $0.1 })}
            }) { [weak self] (state) in
                
                self?.timerSecondsValue = state.timeInterval
                self?.beepValue = state.beepInterval
                
                store.dispatch(RoundInitialAction(progress: 0))
        }
        
        roundAppState = ReduxHelper<RoundState>.init({ (subscirbe) in
                store.subscribe(subscirbe) { $0.select({ $0.roundAppState }).skipRepeats({ $0.0 == $0.1 }) }
            }) { [unowned self] (state) in
                self.updateTo(state: state.roundState)
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
            store.dispatch(RoundTimeInterval(timer: seconds))
        }
        let progress = CGFloat(1 - (CGFloat(seconds) / CGFloat(timerSecondsValue)))
        store.dispatch(RoundProgress(progress: progress))
    }
    
 func updateTo(state: TimerState) {
        timer.invalidate()
        
        switch state {
            
        case .initial: // Restart
            updateTimeInterval(timeInterval: timerSecondsValue)
            
        case .paused: // pause
            store.dispatch(RoundPausedAction())
            
        case .running: // resume if paused or started, state is internal for TimerService. Sound manager connot be sent to Middleware.
            if self.state == .initial {
                SoundManager.startEndSound()
                seconds = timerSecondsValue
            }
            runTimer()
            
        case .isOut: // time is end
            store.dispatch(RoundIsOutAction(timerSecondsValue: timerSecondsValue, beepValue: beepValue))
        }
        self.state = state
    }
    
    func updateTimeInterval(timeInterval: Int) {
        store.dispatch(RoundTimeInterval(timer: timeInterval))
    }
}
