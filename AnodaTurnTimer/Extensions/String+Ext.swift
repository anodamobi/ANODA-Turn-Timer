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
        return characters.count > 0
    }
}
