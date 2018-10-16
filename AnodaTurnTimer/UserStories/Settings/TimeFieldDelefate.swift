//
//  TimeFieldDelefate.swift
//  AnodaTurnTimer
//
//  Created by Serg Liamthev on 10/16/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import UIKit

class TimeFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check max length
        let maxLength = 5
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        // Check if input characters is digits
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet) && newString.length <= maxLength
        
 
        
    }
}
