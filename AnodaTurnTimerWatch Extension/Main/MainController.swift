//
//  InterfaceController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/23/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import WatchKit
import Foundation

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
    @IBOutlet private var ibTimer: WKInterfaceTimer!
    
    private var timer = Timer()
    private var choosenInterval: Double = 0.0
    
    private var startButtonState: StartButtonState = .start {
        didSet {
            ibRestartButton.setTitle(startButtonState.rawValue)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupUI()
        stopTimer()
    }
    
    private func setupUI() {
        ibTimer.setDate(Date().addingTimeInterval(choosenInterval + 1))
        ibRestartButton.setTitle(StartButtonState.start.rawValue)
    }
    
    // MARK: Timer controls
    
    private func startTimer() {
        ibTimer.start()
        timer.fire()
        ibTimer.setTextColor(.green)
    }
    
    private func stopTimer() {
        ibTimer.stop()
        timer.invalidate()
        ibTimer.setTextColor(.red)
    }
    
    private func updateTimer() {
        timer = Timer.scheduledTimer(timeInterval: choosenInterval + 1, target: self, selector: #selector(timerDidFinish), userInfo: nil, repeats: true)
        ibTimer.setDate(Date().addingTimeInterval(choosenInterval + 1))
    }
    
    // MARK: Actions
    
    @IBAction private func didPressRestart() {
        stopTimer()
        updateTimer()
        if startButtonState == .start || startButtonState == .restart {     // Need to fire timer
            startButtonState = .stop
            startTimer()
        } else {
            startButtonState = .start
        }
    }
    
    @objc private func timerDidFinish() {
        let diffToNextFireDate = timer.fireDate.timeIntervalSince(Date())
        if diffToNextFireDate < choosenInterval {
            startButtonState = .restart
            stopTimer()
        }
    }
    
    @IBAction private func didPressSettings() {
        stopTimer()
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
        ibTimer.setDate(Date().addingTimeInterval(choosenInterval + 1))
    }
}
