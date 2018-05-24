//
//  ReduxHelper.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/24/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift

class ReduxHelper<T>: StoreSubscriber where T: StateType {
    var newStateClosure: ( (T)->())?
    
    init(_ subscriptionClosure: (ReduxHelper)->(), newState: @escaping (T)->()) {
        newStateClosure = newState
        //        super.init()
        subscriptionClosure(self)
    }
    
    func newState(state: T) {
        newStateClosure?(state)
    }
    
    deinit {
        store.unsubscribe(self)
    }
}
