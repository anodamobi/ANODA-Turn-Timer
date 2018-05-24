//
//  ViewController.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/10/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import UIKit
import ReSwift

class MainVC: UIViewController, StoreSubscriber {
    
    let contentView: MainView = MainView(frame: CGRect.zero)
    let timer: TimerService = TimerService()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        store.dispatch(RoundInitialAction(progress: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    func newState(state: RoundState) {
        
        contentView.pieView.update(to: state.progress, animated: true)
        
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
        
        updated(timeInterval: state.roundTimeProgress)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.pauseButton.addTargetClosure { (button) in
            let state: TimerState = store.state.roundAppState.roundState
            
            if state == .paused || state == .initial {
                store.dispatch(RoundRunningAction())
            } else if state == .running {
                store.dispatch(RoundPausedAction())
            }
        }
        
        contentView.restartButton.addTargetClosure { (button) in
            store.dispatch(RoundReplayAction(timeValue: store.state.timerAppState.timeInterval,
                                             beepValue: store.state.timerAppState.beepInterval))
            store.dispatch(RoundInitialAction(progress: 0))
            store.dispatch(RoundRunningAction())
        }
        
        contentView.settingsButton.addTargetClosure { (button) in
            store.dispatch(RoundPausedAction())
            self.navigationController?.pushViewController(SettingsVC(), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) { $0.select({ $0.roundAppState }).skipRepeats({$0.0 == $0.1})}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        store.unsubscribe(self)
        super.viewWillDisappear(animated)
    }
    
    func updated(timeInterval: Int) {
        
        var text: String
        text = timeString(time: TimeInterval(timeInterval))
        
        contentView.timerLabel.text = text
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
