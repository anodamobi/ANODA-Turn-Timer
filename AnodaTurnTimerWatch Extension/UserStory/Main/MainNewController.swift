//
//  MainNewController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/23/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

class MainNewController: WKInterfaceController {
    
    @IBOutlet var playButton: WKInterfaceButton!
    
    @IBOutlet var settingsButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    
    @IBAction private func startTimer() {
        pushController(withName: Constants.timerControllerClassName, context: nil)
    }
    
    @IBAction private func openSettings() {
        presentController(withNames: [Constants.roundDurationControllerClassName, Constants.beepIntervalController], contexts: nil)
    }
    
}
