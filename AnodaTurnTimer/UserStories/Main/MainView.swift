//
//  MainView.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/10/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import UIImagePDF
import CoreGraphics

class MainView: UIView {
    
    let background = UIImageView()
    //TODO: constants
    static let frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.width - 40, height: UIScreen.main.bounds.width - 40)
    let pieView = MainPieView(frame: MainView.frame)
    
    let settingsButton = UIButton()
    let pauseButton = UIButton()
    
    var restartButton: UIButton {
        return pieView.restartButton
    }
    
    var timerLabel: UILabel {
        return pieView.timerLabel
    }
    
    func updateRestartIcon(visible: Bool) {
        if visible {
            restartButton.setImage(UIImage.init(pdfNamed: "reset", atHeight: 192), for: .normal)
        } else {
            restartButton.setImage(nil, for: .normal)
        }
        timerLabel.isHidden = visible
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(background)
        background.setImage(UIImage.backgroudImage())
        background.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        addSubview(pieView)
        pieView.snp.makeConstraints { (make) in
            
            let edges = UIEdgeInsetsMake(40, 20, 0, 20)
            let edgesX = UIEdgeInsetsMake(80, 20, 0, 20)
            let edge = UIScreen.screenType == .iphoneX ? edgesX : edges
            
            make.top.left.right.equalTo(self).inset(edge)
            make.height.equalTo(UIScreen.width - edge.left - edge.right)
        }
        
        updatePlay(toPause: false)
        addSubview(pauseButton)
        pauseButton.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(self.safeArea.bottom).offset(-20)
            make.left.equalTo(self).offset(20)
        }
        
        settingsButton.setImage(UIImage.init(pdfNamed: "settingsNormal", atWidth: 100), for: .normal)
        settingsButton.setImage(UIImage.init(pdfNamed: "settingsPressed", atWidth: 100), for: .selected)
        settingsButton.setImage(UIImage.init(pdfNamed: "settingsPressed", atWidth: 100), for: .highlighted)
        addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(pauseButton)
            make.right.equalTo(self).offset(-20)
        }
    }
    
    func updatePlay(toPause: Bool) {
        if toPause {
            pauseButton.setImage(UIImage.init(pdfNamed: "pauseNormal", atWidth: 100), for: .normal)
            pauseButton.setImage(UIImage.init(pdfNamed: "pausePressed", atWidth: 100), for: .selected)
            pauseButton.setImage(UIImage.init(pdfNamed: "pausePressed", atWidth: 100), for: .highlighted)
        } else {
            pauseButton.setImage(UIImage.init(pdfNamed: "playNormal", atWidth: 100), for: .normal)
            pauseButton.setImage(UIImage.init(pdfNamed: "playPressed", atWidth: 100), for: .selected)
            pauseButton.setImage(UIImage.init(pdfNamed: "playPressed", atWidth: 100), for: .highlighted)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainPieView: UIView {
    
    let timerLabel = UILabel()
    let restartButton = UIButton()
    var pieLayer: BRCircularProgressView
    
    override init(frame: CGRect) {

        pieLayer = BRCircularProgressView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(to progress: CGFloat, animated: Bool) {

        UIView.transition(with: pieLayer, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.pieLayer.progress = 1 - progress
        }, completion: nil)
    }

    func layoutViews() {

        addSubview(pieLayer)
        pieLayer.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }


        let ovalPath = UIBezierPath(ovalIn: self.frame)
        let circleStrokeLayer = CAShapeLayer()
        circleStrokeLayer.path = ovalPath.cgPath
        circleStrokeLayer.lineWidth = 10
        circleStrokeLayer.fillColor = UIColor.clear.cgColor
        circleStrokeLayer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor

        self.layer.insertSublayer(circleStrokeLayer, at: 0)

        pieLayer.setCircleStrokeWidth(5)
        pieLayer.setCircleStrokeColor(UIColor.clear,
                                      circleFillColor: UIColor.clear,
                                      progressCircleStrokeColor: UIColor.clear,
                                      progressCircleFillColor: UIColor.white.withAlphaComponent(0.2))

        pieLayer.progress = 1

        addSubview(timerLabel)
        timerLabel.font = UIFont.gtTimerFont()
        timerLabel.textColor = UIColor.gtVeryLightPink
        timerLabel.textAlignment = .center
        timerLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        restartButton.setImage(UIImage(), for: .selected) //todo:
        restartButton.setImage(UIImage(), for: .highlighted)
        addSubview(restartButton)
        restartButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
