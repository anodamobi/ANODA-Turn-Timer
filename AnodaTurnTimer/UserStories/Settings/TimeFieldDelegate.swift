//
//  TimeFieldDelegate.swift
//  AnodaTurnTimer
//
//  Created by Serg Liamthev on 10/17/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import UIKit
import InputMask

class TimeFieldHandler: MaskedTextFieldDelegate {
    
    override func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let input: String = textField.text ?? ""
        textField.text = formatTime(userInput: input)
        return true
    }
    
    func formatTime(userInput: String) -> String {
        let time = String.parseTextToTime(text: userInput)
        return String.timeString(time: TimeInterval(time))
    }
}
