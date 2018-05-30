//
//  ColorScheme+Ext.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/11/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import UIKit

// Color palette

extension UIImage {
    
    static func backgroudImage() -> UIImage? {
        
        var imageName: String
        switch UIScreen.screenType {
            case .iphone6: imageName = "background-i6"
            case .iphonePlus: imageName = "background-i6p"
            default: imageName = "background-i5"
        }
        return UIImage.init(pdfNamed: imageName, atWidth: UIScreen.width)
    }
}

extension UIColor {
    @nonobjc class var gtWhite: UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gtVeryLightPink: UIColor {
        return UIColor(red: 253.0 / 255.0, green: 245.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gtSlateGrey: UIColor {
        return UIColor(red: 89.0 / 255.0, green: 98.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
    }
}

// Text styles
extension UIFont {
    class func gtTimerFont() -> UIFont {
        return R.font.ranchoRegular(size: 130.0) ?? UIFont.systemFont(ofSize: 130.0)
    }
    
    class func gtSettingsDataFont() -> UIFont {
        return R.font.ranchoRegular(size: 75.0) ?? UIFont.systemFont(ofSize: 75.0)
    }
    
    class func gtSubtitleFont() -> UIFont {
        return R.font.ranchoRegular(size: 30.0) ?? UIFont.systemFont(ofSize: 30.0)
    }
    
    class func gtPickerFont() -> UIFont {
        return R.font.ranchoRegular(size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
    }
}
