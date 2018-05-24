//
//  TimerService.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/24/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

protocol TimerServiceDelegate: class {
    func timeOut()
    func timerUpdated()
}

class TimerService {
    
    private var timer = Timer()
    var choosenInterval: Double = 0.0 {
        didSet {
            timeRemaining = choosenInterval
        }
    }
    var timeRemaining: Double = 0.0
    var beepInterval: Double = 1.0   // Seconds before round ends
    
    weak var delegate: TimerServiceDelegate?
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func stopTimer() {
        timeRemaining = choosenInterval
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    func updatedTimerLabelString() -> String {
        let minutesLeft = Int(timeRemaining) / 60 % 60
        let secondsLeft = Int(timeRemaining) % 60
        
        var minutesString = "\(minutesLeft)"
        var secondsString = "\(secondsLeft)"
        
        if minutesLeft < 10 {
            minutesString = "0\(minutesString)"
        }
        
        if secondsLeft < 10 {
            secondsString = "0\(secondsString)"
        }
        
        return "\(minutesString):\(secondsString)"
    }
    
    @objc private func timerUpdate() {
        timeRemaining -= 1
        
        if timeRemaining == beepInterval {
            WKInterfaceDevice.current().play(.notification)
        }
        
        if timeRemaining == 0 {
            delegate?.timeOut()
            WKInterfaceDevice.current().play(.success)
        }
        
        delegate?.timerUpdated()
    }
}
