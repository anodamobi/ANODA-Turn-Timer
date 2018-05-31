//
//  SettingsController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/24/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import WatchKit
import Foundation

enum PickerTimeInterval: Int {
    case sec5 = 5
    case sec10 = 10
    case sec20 = 20
    case sec30 = 30
    case sec45 = 45
    case minute1 = 60
}

class SettingsController: WKInterfaceController {
    
    @IBOutlet private var ibPicker: WKInterfacePicker!
    @IBOutlet private var ibSetButton: WKInterfaceButton!
    
    private var pickerItems: [WKPickerItem] = []
    private var pickedInterval: PickerTimeInterval?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupPicker()
    }
    
    private func setupPicker() {
        let intervals: [PickerTimeInterval] = [.sec5, .sec10, .sec20, .sec30, .sec45, .minute1]
        pickedInterval = intervals.first
        
        for interval in intervals {
            let item = WKPickerItem()
            item.title = "\(interval.rawValue)"
            pickerItems.append(item)
        }
        
        ibPicker.setItems(pickerItems)
    }
    
    @IBAction private func didPickTimeInterval(_ value: Int) {
        let item = pickerItems[value]
        if let itemTitle = Int(item.title ?? "") {
            pickedInterval = PickerTimeInterval(rawValue: itemTitle)
        }
    }
    
    @IBAction private func didPressSetButton() {
        if let interval = pickedInterval {
            let beepInterval = store.state.timerAppState.beepInterval
            let timeInterval = interval.rawValue
            store.dispatch(TimerUpdateSettingsAction(timeInterval: timeInterval,
                                                     beepInterval: beepInterval))
        }
        self.pop()
    }
}
