//
//  UIDevice+Ext.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/11/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import UIKit

public enum ScreenSizes: CGFloat {
    case iphone4 = 480
    case iphone5 = 568
    case iphone6 = 667
    case iphonePlus = 736
    case iphoneX = 812
    case undefined = 1024
}

public extension UIScreen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    
    static var screenType: ScreenSizes {
        if let size = ScreenSizes(rawValue: maxScreenLength()) {
            return size
        }
        return .undefined
    }
    
    private static func maxScreenLength() -> CGFloat {
        let bounds = UIScreen.main.bounds
        return max(bounds.width, bounds.height)
    }
}
