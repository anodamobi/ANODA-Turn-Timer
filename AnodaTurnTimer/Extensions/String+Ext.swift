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
        return self.init(format:"%02i:%02i", minutes, seconds)
    }
    
    static func parseTextToTime(text: String) -> Int {
        // Get round duration
        if(text.contains(":")) {
            let values: [String] = text.components(separatedBy: ":")
            let minutes: Int = (Int(values[0]) ?? 0) * 60
            let seconds: Int = Int(values[1]) ?? 0
            return minutes + seconds
        } else {
            let minutes = Int(text) ?? 0
            return minutes * 60
        }
    }
    
}
