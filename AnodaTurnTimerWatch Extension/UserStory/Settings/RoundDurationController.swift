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
    
    @IBOutlet var secondsPicker: WKInterfacePicker!
    
    let pickersIntervals: [Int] = Array(0...59)
    private var pickerItems: [WKPickerItem] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("Menu")
        setupPickers()
    }
    
    func setupPickers(){
        for interval in pickersIntervals {
            let item = WKPickerItem()
            item.contentImage = WKImage.init(image: item.textToImage(text: String(interval), font: UIFont.pickerItemFont(), color: UIColor.mango))
            pickerItems.append(item)
        }
        minutesPicker.setItems(pickerItems)
        secondsPicker.setItems(pickerItems)
    }
}
