//
//  ShareController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/22/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit

class ShareController: WKInterfaceController {
    
    @IBOutlet var googlePlusButton: WKInterfaceButton!
    @IBOutlet var twitterButton: WKInterfaceButton!
    @IBOutlet var messageButton: WKInterfaceButton!
    @IBOutlet var facebookButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setButtonsActions()
    }
    
    func setButtonsActions(){
        
    }
}
