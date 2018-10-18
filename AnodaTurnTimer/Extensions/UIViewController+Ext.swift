//
//  UIViewController+Ext.swift
//  AnodaTurnTimer
//
//  Created by Serg Liamthev on 10/16/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import UIKit
import Closures

extension UIViewController {
    
    func hideKeyboardOnTap() {
        view.addTapGesture { [unowned self] tap in
            tap.cancelsTouchesInView = false
            self.view.endEditing(true)
        }
    }
}
