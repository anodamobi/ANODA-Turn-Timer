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

fileprivate let sizeConst = UIScreen.width - 40
fileprivate let pieFrame: CGRect = CGRect(x: 0, y: 0, width: sizeConst, height: sizeConst)

class MainView: UIView {
    
    let background = UIImageView()
    let pieView = MainPieView(frame: pieFrame)
    
    let settingsButton = UIButton()
    let pauseButton = UIButton()
    
    var restartButton: UIButton {
        return pieView.restartButton
    }
    
    var timerLabel: UILabel {
        return pieView.timerLabel
    }
    
    func updateRestartIcon(visible: Bool) {
        let image: UIImage = UIImage.init(pdfNamed: "reset", atHeight: 192)
        restartButton.setImage(visible ? image : nil, for: .normal)
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
            
            //HACK (Pavel.Mosunov) to not make a huge constraints for safe area as safeArea ext cannot into EDGES :'(
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
        
        settingsButton.setupButtonImages(imageName: ("settingsNormal", "settingsPressed", "settingsPressed"), width: 100)
        addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(pauseButton)
            make.right.equalTo(self).offset(-20)
        }
    }
    
    func updatePlay(toPause: Bool) {
        if toPause {
            pauseButton.setupButtonImages(imageName: ("pauseNormal", "pausePressed", "pausePressed"), width: 100)
        } else {
            pauseButton.setupButtonImages(imageName: ("playNormal", "playPressed", "playPressed"), width: 100)
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
