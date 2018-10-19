//
//  SettingsView.swift
//  AnodaGameTimer
//
//  Created by Oksana Kovalchuk on 9/11/17.
//  Copyright © 2017 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import InputMask

fileprivate let buttonBackgroundSizeConst: CGFloat = 75.0
fileprivate let buttonSizeConst: CGFloat = 50.0

class SettingsView: UIView {
    
    let backButtonContainerView: UIView = UIView()
    let backButtonBackground: UIImageView = UIImageView()
    let backButton: UIButton = UIButton()
    
    let shareButtonContainerView: UIView = UIView()
    let shareButtonBackground: UIImageView = UIImageView()
    let shareButton: UIButton = UIButton()
    
    let roundDurationSection: SettingsSectionView = SettingsSectionView()
    let beepSection: SettingsSectionView = SettingsSectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        backgroundColor = .white
        
        addSubview(roundDurationSection)
        roundDurationSection.title.text = Localizable.roundDuration()
        roundDurationSection.snp.makeConstraints { [unowned self] (make) in
            make.top.equalTo(self.safeArea.top).offset(25)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 248, height: 137))
        }

        addSubview(beepSection)
        beepSection.title.text = Localizable.beepBeforeRoundEnds(())
        beepSection.snp.makeConstraints { (make) in
            make.top.equalTo(roundDurationSection.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 248, height: 137))
        }
        
        addSubview(backButtonContainerView)
        backButtonContainerView.snp.makeConstraints{ (make) in
            make.top.equalTo(beepSection.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(28)
            make.size.equalTo(buttonBackgroundSizeConst)
        }
        
        backButtonContainerView.addSubview(backButtonBackground)
        backButtonBackground.backgroundColor = UIColor.mango10
        backButtonBackground.layer.cornerRadius = buttonBackgroundSizeConst / 2
        backButtonBackground.clipsToBounds = true
        backButtonBackground.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        
        backButtonContainerView.addSubview(backButton)
        backButton.setupButtonImages(imageName: ("backButtonIcon", "backButtonIconPressed", "backButtonIconPressed"), width: buttonSizeConst)
        backButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(buttonSizeConst)
        }
        
        addSubview(shareButtonContainerView)
        shareButtonContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(beepSection.snp.bottom).offset(25)
            make.right.equalToSuperview().offset(-28)
            make.size.equalTo(buttonBackgroundSizeConst)
        }
        
        shareButtonContainerView.addSubview(shareButtonBackground)
        shareButtonBackground.backgroundColor = UIColor.mango10
        shareButtonBackground.layer.cornerRadius = buttonBackgroundSizeConst / 2
        shareButtonBackground.backgroundColor = UIColor.mango10
        shareButtonBackground.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        
        shareButtonContainerView.addSubview(shareButton)
        shareButton.setupButtonImages(imageName: ("shareButtonIcon", "shareButtonPressedIcon", "shareButtonPressedIcon"), width: buttonSizeConst)
        shareButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(buttonSizeConst)
        }
    }
}


class SettingsSectionView: UIView {
        
    let title: UILabel = UILabel()
    let background: UIView = UIView()
    let timeTextField: UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        
        addSubview(title)
        title.font = UIFont.gtSettingsSubtitleFont()
        title.textAlignment = .center
        title.textColor = UIColor.mango
        title.adjustsFontSizeToFitWidth = true
        title.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        addSubview(background)
        let backgroundHeight: CGFloat = 91.0
        background.backgroundColor = UIColor.mango10
        background.layer.cornerRadius = backgroundHeight/2
        background.clipsToBounds = true
        background.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(backgroundHeight)
            make.width.equalTo(248)
        }
        
        background.addSubview(timeTextField)
        timeTextField.textColor = UIColor.mango
        timeTextField.tintColor = UIColor.gtSlateGrey
        timeTextField.font = UIFont.gtSettingsDataFont()
        timeTextField.keyboardType = .numberPad
        timeTextField.textAlignment = .center
        
        timeTextField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(4, 30, 4, 30))
        }
        
    }
}
