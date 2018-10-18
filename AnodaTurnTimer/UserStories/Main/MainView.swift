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
    
    private let pieViewContainerView = UIView()
    private let pieViewBackgroundImage = UIImageView()
    let pieView = MainPieView(frame: pieFrame)
    
    let settingsButton = UIButton()
    let pauseButton = UIButton()
    let replayButton = UIButton()
    private let buttonsContainerView = UIView()
    private let buttonsBackgroundImage = UIImageView()
    
    var restartButton: UIButton {
        return pieView.restartButton
    }
    
    var timerLabel: UILabel {
        return pieView.timerLabel
    }
    
    func updateRestartIcon(visible: Bool) {
        let image: UIImage = UIImage.init(pdfNamed: "pieViewResetIcon", atHeight: 116)
        restartButton.setImage(visible ? image : nil, for: .normal)
        timerLabel.isHidden = visible
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        backgroundColor = .white
        
        addSubview(pieViewContainerView)
        pieViewContainerView.backgroundColor = UIColor.clear
        pieViewContainerView.snp.makeConstraints { (make) in
            //HACK (Pavel.Mosunov) to not make a huge constraints for safe area as safeArea ext cannot into EDGES :'(
            let edges = UIEdgeInsetsMake(40, 20, 0, 20)
            let edgesX = UIEdgeInsetsMake(80, 20, 0, 20)
            let edge = UIScreen.screenType == .iphoneX ? edgesX : edges
            make.top.left.right.equalTo(self).inset(edge)
            make.height.equalTo(sizeConst)
        }
        
        pieViewContainerView.addSubview(pieViewBackgroundImage)
        pieViewBackgroundImage.setImage(UIImage(pdfNamed: "pieViewBackground", atWidth: sizeConst))
        pieViewBackgroundImage.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        
        pieViewContainerView.addSubview(pieView)
        pieView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(buttonsContainerView)
        buttonsContainerView.snp.makeConstraints {
            $0.top.equalTo(pieViewContainerView.snp.bottom).offset(83)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(125)
        }
        
        buttonsContainerView.addSubview(buttonsBackgroundImage)
        buttonsBackgroundImage.setImage(UIImage(pdfNamed: "buttonsContainerBackground", atWidth: 315))
        buttonsBackgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        buttonsContainerView.addSubview(settingsButton)
        settingsButton.setupButtonImages(imageName: ("settingsIcon", "settingsIcon", "settingsIcon"), width: 50)
        settingsButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(12)
            $0.size.equalTo(50)
        }
        
        buttonsContainerView.addSubview(pauseButton)
        updatePlay(toPause: false)
        pauseButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        buttonsContainerView.addSubview(replayButton)
        replayButton.setupButtonImages(imageName: ("resetIcon", "resetIcon", "resetIcon"), width: 50)
        replayButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-12)
            $0.size.equalTo(50)
        }
    }
    
    func updatePlay(toPause: Bool) {
        if toPause {
            pauseButton.setupButtonImages(imageName: ("pauseButtonIcon", "pauseButtonIcon", "pauseButtonIcon"), width: 100)
        } else {
            pauseButton.setupButtonImages(imageName: ("playButtonIcon", "playButtonIcon", "playButtonIcon"), width: 100)
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

        pieLayer.setCircleStrokeWidth(15)
        pieLayer.setCircleStrokeColor(UIColor.clear,
                                      circleFillColor: UIColor.white,
                                      progressCircleStrokeColor: UIColor.mango,
                                      progressCircleFillColor: UIColor.clear)
        pieLayer.progress = 1

        addSubview(timerLabel)
        timerLabel.font = UIFont.gtTimerFont()
        timerLabel.textColor = UIColor.blackText
        timerLabel.textAlignment = .center
        timerLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        addSubview(restartButton)
        restartButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(67, 67, 64, 43))
        }
    }
}
