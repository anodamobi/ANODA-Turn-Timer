//
//  TimeFieldDelegate.swift
//  AnodaTurnTimer
//
//  Created by Serg Liamthev on 10/17/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import UIKit
import InputMask

class TimeFieldDelegate: MaskedTextFieldDelegate{
    
    override func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let input: String = textField.text ?? ""
        textField.text = formatTime(userInput: input)
        return true
    }
    
    func formatTime(userInput: String) -> String{
        if(userInput.contains(":")){
            let values: [String] = userInput.components(separatedBy: ":")
            let minutes: Int = (values[0] as NSString).integerValue * 60
            let seconds: Int = (values[1] as NSString).integerValue
            return String.timeString(time: TimeInterval(minutes+seconds))
        } else {
            let minutes = userInput as NSString
            return String.timeString(time: TimeInterval(minutes.integerValue * 60))
        }
    }
}
