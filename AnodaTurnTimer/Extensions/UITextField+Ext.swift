//
//  UITextField+Ext.swift
//  AnodaTurnTimer
//
//  Created by Serg Liamthev on 10/19/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import UIKit

extension UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
}
