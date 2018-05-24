//
//  SettingsController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/24/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
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

protocol TimeIntervalPickerDelegate: class {
    func didPickInterval(_ interval: PickerTimeInterval)
}

class SettingsController: WKInterfaceController {
    
    @IBOutlet private var ibPicker: WKInterfacePicker!
    @IBOutlet private var ibSetButton: WKInterfaceButton!
    
    private var pickerItems: [WKPickerItem] = []
    
    weak var delegate: TimeIntervalPickerDelegate?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let instance = context as? TransitionHelper {
            delegate = instance.delegate
        }
        setupPicker()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func setupPicker() {
        let intervals: [PickerTimeInterval] = [.sec5, .sec10, .sec20, .sec30, .sec45, .minute1]
        delegate?.didPickInterval(intervals[0])
        
        for interval in intervals {
            let item = WKPickerItem()
            item.title = "\(interval.rawValue)"
            pickerItems.append(item)
        }
        
        ibPicker.setItems(pickerItems)
    }
    
    @IBAction private func didPickTimeInterval(_ value: Int) {
        let item = pickerItems[value]
        if let itemTitle = Int(item.title ?? ""), let interval = PickerTimeInterval(rawValue: itemTitle) {
                    delegate?.didPickInterval(interval)
        }
    }
    
    @IBAction private func didPressSetButton() {
        self.pop()
    }
}
