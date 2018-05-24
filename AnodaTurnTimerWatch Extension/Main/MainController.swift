//
//  InterfaceController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/23/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class TransitionHelper: NSObject {
    var delegate: TimeIntervalPickerDelegate?
}

fileprivate enum StartButtonState: String {
    case start = "Start"
    case stop = "Stop"
    case restart = "Restart"
}

class MainController: WKInterfaceController {

    @IBOutlet private var ibRestartButton: WKInterfaceButton!
    @IBOutlet private var ibSettingsButton: WKInterfaceButton!
    @IBOutlet private var ibTimerLabel: WKInterfaceLabel!
    
    private var timer = Timer()
    private var choosenInterval: Double = 0.0 {
        didSet {
            timeRemaining = choosenInterval
        }
    }
    private var timeRemaining: Double = 0.0
    private var beepInterval: Double = 1.0   // Seconds before round ends
    
    private let session = WCSession.default
    
    private var startButtonState: StartButtonState = .start {
        didSet {
            ibRestartButton.setTitle(startButtonState.rawValue)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupUI()
        resetTimer()
        setupSession()
    }
    
    private func setupSession() {
        processAppContext()
        session.delegate = self
        session.activate()
    }
    
    private func setupUI() {
        ibRestartButton.setTitle(StartButtonState.start.rawValue)
        updateTimerLabel()
    }
    
    // MARK: Timer controls
    
    private func startTimer() {
        timer.fire()
        ibTimerLabel.setTextColor(.green)
    }
    
    private func stopTimer() {
        if timer.isValid {
            timer.invalidate()
        }
        ibTimerLabel.setTextColor(.red)
    }
    
    private func resetTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        timeRemaining = choosenInterval
        updateTimerLabel()
    }
    
    private func updateTimerLabel() {
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
        
        ibTimerLabel.setText("\(minutesString):\(secondsString)")
    }
    
    // MARK: Actions
    
    @IBAction private func didPressRestart() {
        resetTimer()
        if startButtonState == .start || startButtonState == .restart {
            guard choosenInterval > 0 else { return }
            timeRemaining = choosenInterval
            startButtonState = .stop
            startTimer()
        } else {
            startButtonState = .start
        }
    }
    
    @objc private func timerUpdate() {
        guard startButtonState == .stop else { return }
        
        timeRemaining -= 1
        
        if timeRemaining == beepInterval {
            WKInterfaceDevice.current().play(.notification)
        }
        
        if timeRemaining == 0 {
            startButtonState = .restart
            stopTimer()
            WKInterfaceDevice.current().play(.success)
        }
        
        updateTimerLabel()
    }
    
    @IBAction private func didPressSettings() {
        resetTimer()
        startButtonState = .start
        moveToSettings()
    }
    
    private func moveToSettings() {
        let transitionHelper = TransitionHelper()
        transitionHelper.delegate = self
        self.pushController(withName: "SettingsController", context: transitionHelper)
    }
}

extension MainController: TimeIntervalPickerDelegate {
    func didPickInterval(_ interval: PickerTimeInterval) {
        let pickedTime = Double(interval.rawValue)
        choosenInterval = pickedTime
        updateTimerLabel()
    }
}

extension MainController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if startButtonState == .start || startButtonState == .restart {
            DispatchQueue.main.async { [unowned self] in
                self.processAppContext()
            }
        }
    }
    
    private func processAppContext() {
        if let iPhoneContext = session.receivedApplicationContext as? [String : Double] {
            
            if let interval = iPhoneContext[WatchConnectivityKey.roundDuration.rawValue] {
                choosenInterval = interval
                updateTimerLabel()
            }
            
            if let interval = iPhoneContext[WatchConnectivityKey.beepInterval.rawValue] {
                beepInterval = interval
                debugPrint("BEEP updated")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
