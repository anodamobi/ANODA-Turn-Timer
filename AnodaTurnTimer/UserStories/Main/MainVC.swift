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
    let timer: TimerService
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        timer = TimerService()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
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
            self.contentView.updatePlay(toPause: false)
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
            } else if state == .isOut {
                replayAction()
            }
        }
        
        contentView.restartButton.addTargetClosure { (button) in
            replayAction()
        }
        
        contentView.settingsButton.addTargetClosure { (button) in
            store.dispatch(RoundPausedAction())
            self.navigationController?.pushViewController(SettingsVC(), animated: true)
        }
        
        func replayAction() {
            store.dispatch(RoundReplayAction(timeValue: store.state.timerAppState.timeInterval,
                                             beepValue: store.state.timerAppState.beepInterval))
            store.dispatch(RoundInitialAction(progress: 0))
            store.dispatch(RoundRunningAction())
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
        text = String.timeString(time: TimeInterval(timeInterval))
        
        contentView.timerLabel.text = text
    }
}
