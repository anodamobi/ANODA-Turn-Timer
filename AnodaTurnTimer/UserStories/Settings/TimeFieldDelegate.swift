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
        // Add restcirtion to ditits
        let decimalSet = NSCharacterSet(charactersIn: "0123456789:" )
        let characterSet = CharacterSet(charactersIn: string)
        let isDecimal = decimalSet.isSuperset(of: characterSet)
        // Add restriction to 5 symbols
        let text = textField.text ?? ""
        let newLength = text.count + string.count - range.length
        let isInRange = newLength <= 5
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
            if(string == ""){
                if(text.contains(":")){
                    moveCursor(textField: textField, offset: -1)
                    let newText = String(text.dropLast()) + ":"
                    textField.text = newText
                }
            }
        case 4:
            break
        default:
            break
        }
        // Add restriction to 60 minutes and 60 seconds
        // First and third symbol - only 0-5
        // Second and fourth symbol - all allowed
        let validTimeSet = NSCharacterSet(charactersIn: "012345" )
        var isValidTime: Bool = true
        let charSet = CharacterSet(charactersIn: string)
        switch range.location {
        case 0:
            isValidTime = validTimeSet.isSuperset(of: charSet)
        case 2:
            isValidTime = validTimeSet.isSuperset(of: charSet)
        case 3:
            isValidTime = validTimeSet.isSuperset(of: charSet)
        default:
            break
        }
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
    
    func moveCursor(textField: UITextField, offset: Int){
        if let selectedRange = textField.selectedTextRange {
            if let newPosition = textField.position(from: selectedRange.start, offset: offset) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
}
