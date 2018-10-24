//
//  ViewController.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/10/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import UIKit
import ReSwift
import Closures

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
        contentView.pieView.update(to: CGFloat(state.progress), animated: true)
        
        switch state.roundState {
        case .initial:
            contentView.pieView.update(to: 0, animated: true)
            contentView.updateRestartIcon(visible: false)
            
        case .running:
            contentView.updatePlay(toPause: true)
            
        case .paused:
            contentView.updatePlay(toPause: false)
            
        case .isOut:
            contentView.updateRestartIcon(visible: true)
            contentView.updatePlay(toPause: false)
        }
        
        updated(timeInterval: state.roundTimeProgress)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.restartButton.onTap { [unowned self] in
            self.replayAction()
        }
        
        contentView.pauseButton.onTap { [unowned self] in
            let state: TimerState = store.state.roundAppState.roundState
            
            if state == .paused || state == .initial {
                let endDate = Date().addingTimeInterval(TimeInterval(store.state.timerAppState.timeInterval))
                store.dispatch(RoundEndDate(endDate: endDate))
                store.dispatch(RoundRunningAction())
            } else if state == .running {
                store.dispatch(RoundPausedAction())
            } else if state == .isOut {
                self.replayAction()
            }
        }
        
        contentView.settingsButton.onTap { [unowned self] in
            store.dispatch(RoundPausedAction())
            self.navigationController?.pushViewController(SettingsVC(), animated: true)
        }
        
        contentView.replayButton.onTap { [unowned self] in
            self.replayAction()
        }
    }
    
    func replayAction() {
        store.dispatch(RoundReplayAction(timeValue: store.state.timerAppState.timeInterval,
                                         beepValue: store.state.timerAppState.beepInterval))
        let endDate = Date().addingTimeInterval(TimeInterval(store.state.timerAppState.timeInterval))
        store.dispatch(RoundEndDate(endDate: endDate))
        store.dispatch(RoundInitialAction(progress: 0))
        store.dispatch(RoundRunningAction())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) { $0.select({ $0.roundAppState }).skipRepeats({$0 == $1})}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        store.unsubscribe(self)
        super.viewWillDisappear(animated)
    }
    
    func updated(timeInterval: Int) {
        let text = String.timeString(time: TimeInterval(timeInterval))
        contentView.timerLabel.text = text
    }
}
