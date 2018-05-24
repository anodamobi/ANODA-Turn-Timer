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

protocol DataUpdated: class {
    func loadData()
}

class SettingsVC: UIViewController {
    
    let contentView = SettingsView()
    weak var delegate: DataUpdated?
    
    init(delegate: DataUpdated) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.roundDurationSection.picker.timeInterval = TimeInterval(Defaults[.timerInterval])
        contentView.beepSection.picker.timeInterval = TimeInterval(Defaults[.beepInterval])
        
        contentView.roundDurationSection.picker.addTarget(self,
                                                          action: #selector(timeChanged(_:)),
                                                          for: .valueChanged)
        
        contentView.beepSection.picker.addTarget(self,
                                                 action: #selector(beepChanged(_:)),
                                                 for: .valueChanged)
        
        contentView.backButton.addTargetClosure { (button) in
            Answers.logCustomEvent(withName: "Settings updated",
                                   customAttributes: ["Total": Defaults[.timerInterval], "Beep": Defaults[.beepInterval]])
            self.delegate?.loadData()
            self.navigationController?.popViewController(animated: true)
        }
        
        contentView.shareButton.addTargetClosure { (button) in
            let message = "ANODA Turn Timer. Enjoy games with friends"
            if let link = NSURL(string: "http://itunes.apple.com/app/id1282215925") {
                let objectsToShare: [Any] = [message, link]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [.airDrop, .openInIBooks, .addToReadingList, .assignToContact, .saveToCameraRoll]
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    func timeChanged(_ picker: LETimeIntervalPicker) {
        Defaults[.timerInterval] = Int(picker.timeInterval)
    }
    
    func beepChanged(_ picker: LETimeIntervalPicker) {
        Defaults[.beepInterval] = Int(picker.timeInterval)
    }
}
