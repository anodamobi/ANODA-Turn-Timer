//
//  EventHandler.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/24/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
#if os(iOS)
import Crashlytics
#endif

class AnalyticsHandler {
    
    static func logTimeRestart(timerValue: Int, beepValue: Int) {
        AnalyticsHandler.logEvent(with: "Timer restart", atr: (timerValue, beepValue))
    }
    
    static func logSettingsUpdates(timerValue: Int, beepValue: Int) {
        AnalyticsHandler.logEvent(with: "Settings updated", atr: (timerValue, beepValue))
    }
    
    static func logTimeIsOut(timerValue: Int, beepValue: Int) {
        AnalyticsHandler.logEvent(with: "Time is out", atr: (timerValue, beepValue))
    }
    
    private static func logEvent(with name: String, atr: (Int, Int)) {
        #if os(iOS)
        Answers.logCustomEvent(withName: name, customAttributes: ["Total": atr.0,
                                                                  "Beep": atr.1])
        #endif
    }
}
