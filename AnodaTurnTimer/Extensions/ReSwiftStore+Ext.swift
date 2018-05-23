//
//  ReSwiftStore+Ext.swift
//  AnodaTurnTimer
//
//  Created by Pavel Mosunov on 5/23/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import ReSwift

extension Store {
    
    func dispatchOnMain(_ action: Action) {
        print(action)
        DispatchQueue.main.async {
            store.dispatch(action)
        }
    }
}
