//
//  BeepIntervalController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

class BeepIntervalController: WKInterfaceController {
    
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
        setupPickers()
        setPickersSelectedValues()
    }
    
    func setupPickers() {
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
        updateBeepInterval()
    }
    
    @IBAction func didPickSeconds(_ value: Int) {
        pickedSecondsInterval = pickersIntervals[value]
        updateBeepInterval()
    }
    
    func setPickersSelectedValues() {
        let beepInterval = TimerData.convertToTime(timeInterval: store.state.timerAppState.beepInterval)
        minutesPicker.setSelectedItemIndex(beepInterval.minutes)
        secondsPicker.setSelectedItemIndex(beepInterval.seconds)
    }
    
    func updateBeepInterval() {
        var beepInterval = TimerData.convertToTime(timeInterval: store.state.timerAppState.beepInterval)
        if let newMinutesValue = pickedMinutesInterval {
            beepInterval.minutes = newMinutesValue
        }
        if let newSecondsValue = pickedSecondsInterval {
            beepInterval.seconds = newSecondsValue
        }
        let newBeepInterval = (beepInterval.minutes * 60) +  beepInterval.seconds
        store.dispatch(TimerUpdateSettingsAction(timeInterval: store.state.timerAppState.timeInterval, beepInterval: newBeepInterval))
    }

}
