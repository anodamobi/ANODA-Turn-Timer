//
//  TimerController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/23/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit
import ReSwift
import YOChartImageKit

class TimerController: WKInterfaceController, StoreSubscriber {

    @IBOutlet var timerImageButton: WKInterfaceButton!
    
    let timerRing = YODonutChartImage()
    
    private var timer: TimerService?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("Menu")
        setTimerImage()
        timer = TimerService()
    }
    
    override func willActivate() {
        super.willActivate()
        store.subscribe(self)
        { $0.select({ $0.roundAppState }).skipRepeats({$0 == $1})}
    }
    
    override func willDisappear() {
        store.unsubscribe(self)
        super.willDisappear()
    }
    
    @IBAction func didTimerPressed() {
        let state: TimerState = store.state.roundAppState.roundState
        
        if state == .paused || state == .initial {
            store.dispatch(RoundRunningAction())
        } else if state == .running {
            store.dispatch(RoundPausedAction())
        } else if state == .isOut {
            replayAction()
        }
    }
    
     // MARK: Start of UI methods
    
    func setTimerImage() {
        timerRing.donutWidth = 7.5        // width of donut
        timerRing.labelText = String.timeString(time: TimeInterval(store.state.timerAppState.timeInterval)) // [optional] center label text
        timerRing.labelFont = UIFont.timerTimeFont()
        timerRing.labelColor =  UIColor.white  // [optional] center label color
        let roundProgress = NSNumber(value: store.state.roundAppState.progress * 100)
        let timeSpent = NSNumber(value: (1 - store.state.roundAppState.progress) * 100)
        timerRing.values = [timeSpent, roundProgress]    // chart values
        timerRing.colors = [UIColor.mango, UIColor.timerProgressBackgroundColor] // colors of pieces
        let image = timerRing.draw(CGRect.init(x: 0, y: 0, width: 150, height: 150), scale: WKInterfaceDevice.current().screenScale)   // draw an image
        timerImageButton.setBackgroundImage(image)
    }
    
    func updateTimerImage(timerLabel: String, labelFont: UIFont, isOut: Int? = nil) {
        timerRing.labelText = timerLabel // [optional] center label text
        timerRing.labelFont = labelFont
        var roundProgress: NSNumber = 0
        var timeSpent: NSNumber = 0
        if let roundFinished = isOut {
            roundProgress = NSNumber(value: roundFinished * 100)
            timeSpent = 0
        } else {
            roundProgress = NSNumber(value: store.state.roundAppState.progress * 100)
            timeSpent = NSNumber(value: (1 - store.state.roundAppState.progress) * 100)
        }
        timerRing.values = [timeSpent, roundProgress]    // chart values
        let image = timerRing.draw(CGRect.init(x: 0, y: 0, width: 150, height: 150), scale: WKInterfaceDevice.current().screenScale)   // draw an image
        timerImageButton.setBackgroundImage(image)
    }
    
    // MARK: End of UI methods
    
    private func replayAction() {
        store.dispatch(RoundReplayAction(timeValue: store.state.timerAppState.timeInterval,
                                         beepValue: store.state.timerAppState.beepInterval))
        let start = Date()
        let endDate = start.addingTimeInterval(TimeInterval(store.state.timerAppState.timeInterval))
        store.dispatch(RoundEndDate(endDate: endDate))
        store.dispatch(RoundInitialAction(progress: 0))
        store.dispatch(RoundRunningAction())
    }
    
    func newState(state: RoundState) {
        switch state.roundState {
        case .initial:
            updateTimerImage(timerLabel: String.timeString(time: TimeInterval(store.state.timerAppState.timeInterval)), labelFont: UIFont.timerTimeFont())
        case .running:
            updateTimerImage(timerLabel: String.timeString(time: TimeInterval(store.state.roundAppState.roundTimeProgress)), labelFont: UIFont.timerTimeFont())
            break
        case .paused:
            updateTimerImage(timerLabel: String.timeString(time: TimeInterval(store.state.roundAppState.roundTimeProgress)), labelFont: UIFont.timerTimeFont())
            break
        case .isOut:
            updateTimerImage(timerLabel: "Replay", labelFont: UIFont.timerReplayFont(), isOut: 1)
            break
        }
    }
    
}
