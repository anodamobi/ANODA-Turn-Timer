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
        Sound.play(file: "start_end.mp3")
    }
    
    static func alertSound() {
        Sound.play(file: "alarm.mp3")
    }
}
