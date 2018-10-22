//
//  TimeFieldDelegate.swift
//  AnodaTurnTimer
//
//  Created by Serg Liamthev on 10/17/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import UIKit

extension SettingsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isDecimal = checkDecimalDigits(newString: string)
        let isInRange = checkTextMaxCount(textFieldText: textField.text ?? "", newString: string, at: range, maxCount: 5)
        addColonSeparator(textField: textField, newString: string, at: range)
        let isValidTime: Bool = checkMinutesAndSeconds(newString: string, rangeLocation: range.location)
        return isDecimal && isInRange && isValidTime
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let input: String = textField.text ?? ""
        textField.text = formatTime(userInput: input)
        return true
    }
    
    func formatTime(userInput: String) -> String {
        let time = String.parseTextToTime(text: userInput)
        return String.timeString(time: TimeInterval(time))
    }
    
    func moveCursor(textField: UITextField, offset: Int) {
        if let selectedRange = textField.selectedTextRange {
            if let newPosition = textField.position(from: selectedRange.start, offset: offset) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    // MARK: Text field validation methods
    
    func checkTextMaxCount(textFieldText: String, newString: String, at range: NSRange, maxCount: Int) -> Bool {
        // Add restriction to 5 symbols
        let newLength = textFieldText.count + newString.count - range.length
        return newLength <= maxCount
    }
    
    func checkDecimalDigits(newString: String) -> Bool {
        // Add restcirtion to ditits
        let decimalSet = NSCharacterSet(charactersIn: "0123456789:")
        let characterSet = CharacterSet(charactersIn: newString)
        return decimalSet.isSuperset(of: characterSet)
    }
    
    func addColonSeparator(textField: UITextField, newString: String, at range: NSRange) {
        let text = textField.text ?? ""
        // Add colon separator
        switch range.location {
        case 0:
            if(text.contains(":")) {
                textField.text = ""
            }
        case 2:
            if(text.contains(":")) {
                textField.text = text
                moveCursor(textField: textField, offset: 1)
            } else {
                textField.text = text + ":"
            }
        case 3:
            if newString.isEmpty, text.contains(":") {
                moveCursor(textField: textField, offset: -1)
                let newText = String(text.dropLast()) + ":"
                textField.text = newText
            }
        case 4:
            break
        default:
            break
        }
    }
    
    func checkMinutesAndSeconds(newString: String, rangeLocation: Int) -> Bool {
        // Add restriction to 60 minutes and 60 seconds
        // First and third symbol - only 0-5
        // Second and fourth symbol - all allowed
        let validTimeSet = NSCharacterSet(charactersIn: "012345" )
        var isValidTime: Bool = true
        let charSet = CharacterSet(charactersIn: newString)
        switch rangeLocation {
        case 0:
            isValidTime = validTimeSet.isSuperset(of: charSet)
        case 2:
            isValidTime = validTimeSet.isSuperset(of: charSet)
        case 3:
            isValidTime = validTimeSet.isSuperset(of: charSet)
        default:
            break
        }
        return isValidTime
    }
}
