//
//  SoundManager.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/24/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import SwiftySound

class SoundManager {
    
    static func startEndSound() {
        if let url = R.file.start_endMp3() {
            Sound.play(url: url)
        }
    }
    
    static func alertSound() {
        if let url = R.file.alarmMp3() {
            Sound.play(url: url)
        }
    }
}
