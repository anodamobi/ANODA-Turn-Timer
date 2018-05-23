//
//  ViewController.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/10/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import UIKit
import SwiftySound
import SwiftyUserDefaults
import Crashlytics
import ReSwift

class MainVC: UIViewController, StoreSubscriber {
    
    let contentView: MainView = MainView(frame: CGRect.zero)
    let timer: TimerService = TimerService()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        timer.delegate = self
        store.subscribe(self) { $0.select({ $0.roundState })}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    func newState(state: RoundState) {
        contentView.pieView.update(to: state.progress, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.pauseButton.addTargetClosure { (button) in
            
            if self.timer.state == .paused || self.timer.state == .initial {
                self.timer.updateTo(state: .running)
            } else if self.timer.state == .running {
                self.timer.updateTo(state: .paused)
            }
        }
        
        contentView.restartButton.addTargetClosure { (button) in
            Answers.logCustomEvent(withName: "Timer restart",
                                   customAttributes: ["Total": self.timer.timerSecondsValue, "Beep": self.timer.beepValue])
            self.timer.updateTo(state: .initial)
            self.timer.updateTo(state: .running)
        }
        
        contentView.settingsButton.addTargetClosure { (button) in
            self.navigationController?.pushViewController(SettingsVC.init(delegate: self.timer), animated: true)
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if minutes > 0 {
            return  String(format:"%02i:%02i", minutes, seconds)
        } else {
            return  String(format:"%i", seconds)
        }
    }
}

extension MainVC: TimerDelegate {
    
    func updated(state: TimerState) {
        switch state {
        case .initial:
            contentView.pieView.update(to: 0, animated: true)
            contentView.updateRestartIcon(visible: false)
        case .running:
            self.contentView.updatePlay(toPause: true)
        case .paused:
            self.contentView.updatePlay(toPause: false)
        case .isOut:
            
            store.dispatch(TimerIsOutAction(timerSecondsValue: timer.timerSecondsValue, beepValue: timer.beepValue))
            self.contentView.updateRestartIcon(visible: true)
        }
    }

    
    func updated(timeInterval: Int?) {
        
        var text: String
        
        if let time = timeInterval {
            text = timeString(time: TimeInterval(time))
        } else {
            text = ""
        }
        contentView.timerLabel.text = text
    }
}
