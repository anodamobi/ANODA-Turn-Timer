//
//  MainNewController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/23/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class MainController: WKInterfaceController {
    
    @IBOutlet var playButton: WKInterfaceButton!
    
    @IBOutlet var settingsButton: WKInterfaceButton!
    
    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupSession()
    }
    
    private func setupSession() {
        processAppContext()
        session.delegate = self
        session.activate()
    }
    
    @IBAction private func startTimer() {
        pushController(withName: Constants.timerControllerClassName, context: "stub")
    }
    
    @IBAction private func openSettings() {
        presentController(withNames: [Constants.roundDurationControllerClassName, Constants.beepIntervalController], contexts: ["stub", "stub"])
    }
    
}
