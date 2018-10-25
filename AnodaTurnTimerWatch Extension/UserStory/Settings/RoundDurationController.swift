//
//  RoundDurationController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

class RoundDurationController: WKInterfaceController {
    
    @IBOutlet var minutesPicker: WKInterfacePicker!
    @IBOutlet var minutesPickerContainer: WKInterfaceGroup!
    
    @IBOutlet var secondsPicker: WKInterfacePicker!
    @IBOutlet var secondsPickerContainer: WKInterfaceGroup!
    
    private let pickersIntervals: [Int] = Array(0...59)
    private var pickerItems: [WKPickerItem] = []
    
    private var pickedMinutesInterval: Int?
    private var pickedSecondsInterval: Int?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("<Menu")
        setupPickersValues()
        setPickersSelectedValues()
    }
    
    func setupPickersValues() {
        for interval in pickersIntervals {
            let item = WKPickerItem()
            item.contentImage = WKImage(image: item.textToImage(text: String(interval), font: UIFont.pickerItemFont(), color: UIColor.mango))
            pickerItems.append(item)
        }
        minutesPicker.setItems(pickerItems)
        secondsPicker.setItems(pickerItems)
    }
    
    override func pickerDidFocus(_ picker: WKInterfacePicker) {
        super.pickerDidFocus(picker)
        switch picker {
        case minutesPicker:
            minutesPickerContainer.setBackgroundImage(UIImage(named: "pickerSelectedBorder"))
        case secondsPicker:
            secondsPickerContainer.setBackgroundImage(UIImage(named: "pickerSelectedBorder"))
        default:
            break
        }
    }
    
    override func pickerDidResignFocus(_ picker: WKInterfacePicker) {
        super.pickerDidResignFocus(picker)
        switch picker {
        case minutesPicker:
            minutesPickerContainer.setBackgroundImage(nil)
        case secondsPicker:
            secondsPickerContainer.setBackgroundImage(nil)
        default:
            break
        }
    }
    
    @IBAction func didPickMinutes(_ value: Int) {
        pickedMinutesInterval = pickersIntervals[value]
        updateTimeInterval()
    }
    
    @IBAction func didPickSeconds(_ value: Int) {
        pickedSecondsInterval = pickersIntervals[value]
        updateTimeInterval()
    }
    
    func setPickersSelectedValues() {
        let timeInterval = getTimerTimeInterval()
        minutesPicker.setSelectedItemIndex(timeInterval.minutes)
        secondsPicker.setSelectedItemIndex(timeInterval.seconds)
    }
    
    func updateTimeInterval() {
        var timeInterval = getTimerTimeInterval()
        if let newMinutesValue = pickedMinutesInterval {
            timeInterval.minutes = newMinutesValue
        }
        if let newSecondsValue = pickedSecondsInterval {
            timeInterval.seconds = newSecondsValue
        }
        let newTimeInterval = (timeInterval.minutes * 60) +  timeInterval.seconds
        store.dispatch(TimerUpdateSettingsAction(timeInterval: newTimeInterval, beepInterval: store.state.timerAppState.beepInterval))
    }
    
    func getTimerTimeInterval() -> TimerTimeInterval {
        let timeInterval = store.state.timerAppState.timeInterval
        let minutes = Int(timeInterval / 60)
        let seconds = Int(timeInterval) % 60
        return TimerTimeInterval(minutes: minutes, seconds: seconds)
    }
    
}
