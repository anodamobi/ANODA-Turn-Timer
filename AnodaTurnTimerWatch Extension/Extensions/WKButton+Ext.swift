//
//  WKButton+Ext.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Alexander Kravchenko on 5/25/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

extension WKInterfaceButton {
    func setTitleWithColor(title: String, color: UIColor) {
        let attString = NSMutableAttributedString(string: title)
        attString.setAttributes([NSAttributedStringKey.foregroundColor: color], range: NSMakeRange(0, attString.length))
        self.setAttributedTitle(attString)
    }
}
