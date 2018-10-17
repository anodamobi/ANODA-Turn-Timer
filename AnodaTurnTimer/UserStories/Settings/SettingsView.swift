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

class SettingsView: UIView {

    let background: UIImageView = UIImageView()
    
    let backButton: UIButton = UIButton()
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
        roundDurationSection.title.text = Localizable.roundDuration(())
        roundDurationSection.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeArea.top).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(137)
            make.width.equalTo(248)
        }

        addSubview(beepSection)
        beepSection.title.text = Localizable.beepBeforeRoundEnds(())
        beepSection.snp.makeConstraints { (make) in
            make.top.equalTo(roundDurationSection.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.height.equalTo(137)
            make.width.equalTo(248)
        }
        
        addSubview(backButton)
        backButton.setupButtonImages(imageName: ("backButtonIcon", "backButtonIcon", "backButtonIcon"), width: 75)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(beepSection.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(28)
            make.height.width.equalTo(75)
        }
        
        addSubview(shareButton)
        shareButton.setupButtonImages(imageName: ("shareButtonIcon", "shareButtonIcon", "shareButtonIcon"), width: 75)
        shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(beepSection.snp.bottom).offset(25)
            make.right.equalToSuperview().offset(-28)
            make.height.width.equalTo(75)
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
            make.centerX.equalTo(self)
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
            make.centerY.equalTo(background.snp.centerY)
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(4, 30, 4, 30))
        }
        
    }
}
