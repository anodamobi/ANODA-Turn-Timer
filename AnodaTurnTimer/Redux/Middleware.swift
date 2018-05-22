//
//  Middleware.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift

let logOnOutMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            switch action {
            case let actionState as TimerInitialAction:
                break
            default:
                break
            }

            next(action)
        }
    }
}
