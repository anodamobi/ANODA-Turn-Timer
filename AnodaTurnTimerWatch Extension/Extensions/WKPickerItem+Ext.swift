//
//  WKPickerItem+Ext.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

extension WKPickerItem {
    
    func textToImage(text: String, font: UIFont, color: UIColor) -> UIImage {
        let attributes = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.font: font
        ]
        let textSize = text.size(withAttributes: attributes)
        UIGraphicsBeginImageContextWithOptions(textSize, true, 0)
        text.draw(at: CGPoint.zero, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage.init()
    }

}
