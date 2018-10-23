//
//  TimerController.swift
//  AnodaTurnTimerWatch Extension
//
//  Created by Serg Liamthev on 10/23/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import WatchKit
import YOChartImageKit

class TimerController: WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!
    
    let timerRing = YODonutChartImage()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setUpTimerRing()
    }
    
    func setUpTimerRing() {        
        timerRing.donutWidth = 7.5        // width of donut
        timerRing.labelText = "20:20"       // [optional] center label text
        timerRing.labelFont = UIFont.timerTimeFont()
        timerRing.labelColor =  UIColor.white  // [optional] center label color
        timerRing.values = [70.0, 20.0]    // chart values
        timerRing.colors = [UIColor.mango, UIColor.timerProgressBackgroundColor] // colors of pieces
        let timerImage = timerRing.draw(WKInterfaceDevice.current().screenBounds, scale: WKInterfaceDevice.current().screenScale)   // draw an image
        image.setImage(timerImage)
    }

}
