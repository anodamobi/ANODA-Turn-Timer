//
//  EventHandler.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/24/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import Crashlytics

class EventHandler {
    
    static func logTimeRestart(timerValue: Int, beepValue: Int) {
        EventHandler.logEvent(with: "Timer restart", atr: (timerValue, beepValue))
    }
    
    static func logSettingsUpdates(timerValue: Int, beepValue: Int) {
        EventHandler.logEvent(with: "Settings updated", atr: (timerValue, beepValue))
    }
    
    static func logTimeIsOut(timerValue: Int, beepValue: Int) {
        EventHandler.logEvent(with: "Time is out", atr: (timerValue, beepValue))
    }
    
    private static func logEvent(with name: String, atr: (Int, Int)) {
        Answers.logCustomEvent(withName: name, customAttributes: ["Total": atr.0,
                                                                  "Beep": atr.1])
    }
}
