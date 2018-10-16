//
//  UIViewController+Ext.swift
//  AnodaTurnTimer
//
//  Created by Serg Liamthev on 10/16/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
