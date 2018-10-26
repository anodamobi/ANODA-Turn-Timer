//
//  TimerTimeInterval.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/25/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation

struct TimerData {
    var minutes: Int = 0
    var seconds: Int = 0
        
    static func convertToTime(timeInterval: Int) -> TimerData {
        let minutes = Int(timeInterval / 60)
        let seconds = Int(timeInterval) % 60
        return TimerData(minutes: minutes, seconds: seconds)
    }

}

