//
//  SettingsVC.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/10/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults
import Crashlytics
import IQKeyboardManagerSwift
import InputMask

class SettingsVC: UIViewController, MaskedTextFieldDelegateListener {
    
    let textFieldHandler: MaskedTextFieldDelegate = TimeFieldHandler()
    
    let contentView = SettingsView()
    
    var timeInterval: Int = 0
    var beepInterval: Int = 0
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeInterval = store.state.timerAppState.timeInterval
        beepInterval = store.state.timerAppState.beepInterval
        
        contentView.roundDurationSection.timeTextField.text = String.timeString(time: TimeInterval(timeInterval))
        contentView.beepSection.timeTextField.text = String.timeString(time: TimeInterval(beepInterval))
        
        contentView.backButton.addTargetClosure { [unowned self] (button) in
            self.updateTimerSettings()
            store.dispatch(TimerUpdateSettingsAction(timeInterval: self.timeInterval,
                                                     beepInterval: self.beepInterval))
            self.navigationController?.popViewController(animated: true)
        }
        
        contentView.shareButton.addTargetClosure { (button) in
            let message =  Localizable.turnTimer()
            if let link = NSURL(string: "http://itunes.apple.com/app/id1282215925") {
                let objectsToShare: [Any] = [message, link]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [.airDrop, .openInIBooks, .addToReadingList, .assignToContact, .saveToCameraRoll]
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        
        textFieldHandler.affinityCalculationStrategy = .prefix
        textFieldHandler.affineFormats = [ "[00]{:}[00]" ]
        textFieldHandler.delegate = self
        
        contentView.roundDurationSection.timeTextField.delegate = textFieldHandler
        contentView.roundDurationSection.timeTextField.tag = 0
        contentView.beepSection.timeTextField.delegate = textFieldHandler
        contentView.beepSection.timeTextField.tag = 1
        
        self.hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    func updateTimerSettings(){
        guard let roundDurationValue = contentView.roundDurationSection.timeTextField.text, let beepIntervalValue = contentView.beepSection.timeTextField.text else{
            return
        }
        // Get round duration
        timeInterval = parseTextToTime(userInput: roundDurationValue)
        // Get beep duration
        beepInterval = parseTextToTime(userInput: beepIntervalValue)        
        // Update watch OS values
        WatchConnectivityService.shared.updateTimeInterval(interval: TimeInterval(timeInterval), type: .roundDuration)
        WatchConnectivityService.shared.updateTimeInterval(interval: TimeInterval(beepInterval), type: .beepInterval)
    }
    
    func parseTextToTime(userInput: String) -> Int{
        // Get round duration
        if(userInput.contains(":")){
            let values: [String] = userInput.components(separatedBy: ":")
            let minutes: Int = (values[0] as NSString).integerValue * 60
            let seconds: Int = (values[1] as NSString).integerValue
            return minutes + seconds
        } else {
            let minutes = userInput as NSString
            return minutes.integerValue * 60
        }
    }
    
}
