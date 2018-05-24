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

        store.dispatch(RoundInitialAction(timer: 0))
        store.subscribe(self) { $0.select({ $0.roundAppState })}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    func newState(state: RoundState) {
        
        contentView.pieView.update(to: state.progress, animated: true)
        
        updated(timeInterval: state.timeInterval)
        
        switch state.roundState {
        case .initial:
            
            contentView.pieView.update(to: 0, animated: true)
            contentView.updateRestartIcon(visible: false)
            
        case .running:
            self.contentView.updatePlay(toPause: true)
            
        case .paused:
            self.contentView.updatePlay(toPause: false)
            
        case .isOut:
            self.contentView.updateRestartIcon(visible: true)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.pauseButton.addTargetClosure { (button) in
            
            let state: TimerState = store.state.roundAppState.roundState
            
            if state == .paused || state == .initial {
                store.dispatch(RoundRunningAction())
//                self.timer.updateTo(state: .running)
            } else if state == .running {
                store.dispatch(RoundPausedAction())
//                self.timer.updateTo(state: .paused)
            }
        }
        
        contentView.restartButton.addTargetClosure { (button) in
            
            Answers.logCustomEvent(withName: "Timer restart",
                                   customAttributes: ["Total": self.timer.timerSecondsValue, "Beep": self.timer.beepValue])
            
            store.dispatch(RoundInitialAction(timer: 0))
            store.dispatch(RoundRunningAction())
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
    
    func updated(timeInterval: Int) {
        
        var text: String
        text = timeString(time: TimeInterval(timeInterval))
        
        contentView.timerLabel.text = text
    }
}
