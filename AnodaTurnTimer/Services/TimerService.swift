//
//  TimerService.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/12/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift
#if os(watchOS)
import WatchKit
#endif

class TimerService: NSObject {
    
    var timer = Timer()
    
    var state: TimerState = .initial
    
    private var timerAppState: ReduxHelper<TimerAppState>?
    private var roundAppState: ReduxHelper<RoundState>?
    
    
    override init() { 
        super.init()
        setupSubscription()
    }
    
    func setupSubscription() {
        
        timerAppState = ReduxHelper<TimerAppState>.init({ (subscriber) in
            store.subscribe(subscriber) { $0.select({ $0.timerAppState } ).skipRepeats({ $0 == $1 })}
        }) { (state) in
            store.dispatch(RoundInitialAction(progress: 0))
        }
        
        roundAppState = ReduxHelper<RoundState>.init({ (subscirbe) in
            store.subscribe(subscirbe) { $0.select({ $0.roundAppState }).skipRepeats({ $0 == $1 }) }
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
        debugPrint("\(store.state.roundAppState.roundTimeProgress)")
    }
    
    @objc func updateTimer() {
        checkTimerEndDate()
        if store.state.roundAppState.roundTimeProgress <= 1 {
            updateTo(state: .isOut)
            return
        } else if store.state.roundAppState.roundState == .paused {
            return
        } else {
            let seconds = store.state.roundAppState.roundTimeProgress - 1
            store.dispatch(RoundTimeInterval(timer: seconds))
        }
        let timeToEnd = store.state.roundAppState.roundTimeProgress
        let interval = store.state.timerAppState.timeInterval
        let progress: Double = 1 - Double(timeToEnd) / Double(interval)
        store.dispatch(RoundProgress(progress: progress))
    }
    
    func updateTo(state: TimerState) {
        timer.invalidate()
        
        switch state {
            
        case .initial: // Restart
            updateTimeInterval(timeInterval: store.state.timerAppState.timeInterval)
            
        case .paused: // pause
            store.dispatch(RoundPausedAction())
            
        case .running: // resume if paused or started, state is internal for TimerService. Sound manager connot be sent to Middleware.
            if self.state == .initial {
                store.dispatch(RoundTimeInterval(timer: store.state.timerAppState.timeInterval))
                #if os(iOS)
                SoundManager.startEndSound()
                #elseif os(watchOS)
                WKInterfaceDevice.current().play(.success)
                #endif
            }
            runTimer()
        case .isOut: // time is end
            store.dispatch(RoundIsOutAction(timerSecondsValue: store.state.timerAppState.timeInterval,
                                            beepValue: store.state.timerAppState.beepInterval))
        }
        self.state = state
    }
    
    func updateTimeInterval(timeInterval: Int) {
        store.dispatch(RoundTimeInterval(timer: timeInterval))
    }
    
    func checkTimerEndDate() {
        // Update RoundState.roundTimeProgress and time interval
        guard let endDate = store.state.roundAppState.endDate else {
            return
        }
        let timeToEnd = endDate.timeIntervalSince(Date()).rounded(.up)
        if timeToEnd >= 1 {
            // Update storage values
            let interval = store.state.timerAppState.timeInterval
            let progress = 1 - timeToEnd / Double(interval)
            store.dispatch(RoundProgress(progress: progress))
            store.dispatch(RoundTimeInterval(timer: Int(timeToEnd)))
        } else {
            // Round already finished
            store.dispatch(RoundProgress(progress: 1.0))
            store.dispatch(RoundTimeInterval(timer: 0))
        }
    }
}
