//
//  ColorScheme+Ext.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

// Text styles
extension UIFont {
    class func pickerItemFont() -> UIFont {
        return UIFont.init(name: Constants.appFontName, size: 27.0) ?? UIFont.systemFont(ofSize: 27.0)
    }
}
