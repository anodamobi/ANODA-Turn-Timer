//
//  String+Ext.swift
//  PranaHeart
//
//  Created by Oksana Kovalchuk on 8/17/17.
//  Copyright © 2017 PranaHeart. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func isNotEmpty() -> Bool {
        return count > 0
    }
    
    static func timeString(time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time) % 60
        return  self.init(format:"%02i:%02i", minutes, seconds)
    }
    
}
