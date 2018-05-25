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
        
        addSubview(background)
        background.setImage(UIImage.backgroudImage())
        background.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        addSubview(backButton)
        backButton.setupButtonImages(imageName: ("cancelNormal", "cancelPressed", "cancelPressed"), width: 75)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeArea.top).offset(25)
            make.left.equalTo(10)
        }
        
        addSubview(shareButton)
        shareButton.setupButtonImages(imageName: ("shareNormal", "sharePressed", "sharePressed"), width: 75)
        shareButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(backButton)
        }
        
        addSubview(roundDurationSection)
        roundDurationSection.title.text = Localizable.roundDuration()
        roundDurationSection.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(250)
        }
        
        addSubview(beepSection)
        beepSection.picker.tag = 1
        beepSection.title.text = Localizable.beepBeforeRoundEnds()
        beepSection.snp.makeConstraints { (make) in
            make.top.equalTo(roundDurationSection.snp.bottom).offset(16)
            make.width.equalTo(roundDurationSection)
            make.height.equalTo(roundDurationSection)
        }
    }
}


class SettingsSectionView: UIView {
    
    let title: UILabel = UILabel()
    let background: UIView = UIView()
    let picker: LETimeIntervalPicker = LETimeIntervalPicker()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        
        addSubview(title)
        title.font = UIFont.gtSubtitleFont()
        title.textAlignment = .center
        title.textColor = UIColor.gtVeryLightPink
        title.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(44)
        }
        
        addSubview(background)
        background.backgroundColor = UIColor.gtVeryLightPink
        background.layer.cornerRadius = 85
        background.clipsToBounds = true
        background.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.centerX.equalTo(self)
            make.height.equalTo(170)
            make.width.equalTo(320)
        }
        
        background.addSubview(picker)
        picker.unitsStyle = .short
        picker.components = [.minutes, .seconds]
        picker.textFont = UIFont.gtPickerFont()
        picker.numberFont = UIFont.gtPickerFont()
        picker.tintColor = UIColor.white
        picker.snp.makeConstraints { (make) in
            make.edges.equalTo(background)
        }
    }
}
