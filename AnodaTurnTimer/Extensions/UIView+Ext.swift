//
//  UIView+Ext.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/25/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import SnapKit

extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        
        #if swift(>=3.2)
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
        #else
        return self.snp
        #endif
    }
}
