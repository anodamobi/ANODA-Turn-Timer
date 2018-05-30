//
//  InterfaceController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/23/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ReSwift

class TransitionHelper: NSObject {
    var delegate: TimeIntervalPickerDelegate?
}

enum StartButtonState {
    case start
    case stop
    case restart
    
    var title: String {
        switch self {
        case .start:
            return "start-button-start".localized
        case .stop:
            return "start-button-stop".localized
        case .restart:
            return "start-button-restart".localized
        }
    }
}

class MainController: WKInterfaceController, StoreSubscriber {

    @IBOutlet private var ibRestartButton: WKInterfaceButton!
    @IBOutlet private var ibSettingsButton: WKInterfaceButton!
    @IBOutlet private var ibTimerButton: WKInterfaceButton!
    
    let session = WCSession.default
    let timerService = WatchTimerService()
    
    var startButtonState: StartButtonState = .start {
        didSet {
            ibRestartButton.setTitle(startButtonState.title)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupUI()
        stopTimer()
        setupSession()
        timerService.delegate = self
    }
    
    private func setupSession() {
        processAppContext()
        session.delegate = self
        session.activate()
    }
    
    private func setupUI() {
        ibRestartButton.setTitle(StartButtonState.start.title)
        updateTimerLabel()
    }
    
    
    func updateTimerLabel() {
        let title = timerService.updatedTimerLabelString()
        let color = timerService.isTimerOn ? UIColor.apple : UIColor.lipstick
        ibTimerButton.setTitleWithColor(title: title, color: color)
    }
    
    // MARK: Timer controls
    
    private func startTimer() {
        timerService.startTimer()
    }
    
    private func stopTimer() {
        timerService.stopTimer()
        updateTimerLabel()
    }
    
    // MARK: Actions
    
    @IBAction private func didPressRestart() {
        stopTimer()
        if startButtonState == .start || startButtonState == .restart {
            guard timerService.choosenInterval > 0 else { return }
            timerService.timeRemaining = timerService.choosenInterval
            startButtonState = .stop
            startTimer()
        } else {
            startButtonState = .start
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
        self.pushController(withName: Constants.settingsControllerClassName, context: transitionHelper)
    }
    
    func newState(state: RoundState) {
        
//        contentView.pieView.update(to: state.progress, animated: true)
        
        switch state.roundState {
        case .initial:
//            contentView.pieView.update(to: 0, animated: true)
//            contentView.updateRestartIcon(visible: false)
            break
            
        case .running:
//            self.contentView.updatePlay(toPause: true)
            break
            
        case .paused:
//            self.contentView.updatePlay(toPause: false)
            break
            
        case .isOut:
//            self.contentView.updateRestartIcon(visible: true)
            break
        }
        
//        updated(timeInterval: state.roundTimeProgress)
    }

}

extension MainController: TimeIntervalPickerDelegate {
    func didPickInterval(_ interval: PickerTimeInterval) {
        let pickedTime = Double(interval.rawValue)
        timerService.choosenInterval = pickedTime
        updateTimerLabel()
    }
}

extension MainController: TimerServiceDelegate {
    func timerUpdated() {
        updateTimerLabel()
    }
    
    func timeOut() {
        startButtonState = .restart
        stopTimer()
    }
}
