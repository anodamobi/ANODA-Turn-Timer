//
//  ColorScheme+Ext.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

extension UIColor {
    @nonobjc class var timerProgressBackgroundColor: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.2)
    }
}

// Text styles
extension UIFont {
    class func pickerItemFont() -> UIFont {
        return UIFont.init(name: Constants.appFontName, size: 27.0) ?? UIFont.systemFont(ofSize: 27.0)
    }
    
    class func timerTimeFont() -> UIFont {
        return UIFont.init(name: Constants.appFontName, size: 32.0) ?? UIFont.systemFont(ofSize: 32.0)
    }
    
    class func timerReplayFont() -> UIFont {
        return UIFont.init(name: Constants.appFontName, size: 27.0) ?? UIFont.systemFont(ofSize: 27.0)
    }
}
