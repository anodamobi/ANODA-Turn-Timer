//
//  Storage.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/11/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let timerInterval = DefaultsKey<Int>("timer")
    static let beepInterval = DefaultsKey<Int>("beep")
    static let wasLaunched = DefaultsKey<Bool>("wasLaunched")
}
