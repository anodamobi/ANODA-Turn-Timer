//
//  UIButton+Ext.swift
//  
//
//  Created by Oksana Kovalchuk on 8/17/17.
//

import Foundation
import UIKit

typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    func setupButtonImages(imageName: (nrm: String, slc: String, hld: String), width: CGFloat) {
        self.setImage(UIImage.init(pdfNamed: imageName.nrm, atWidth: width), for: .normal)
        self.setImage(UIImage.init(pdfNamed: imageName.slc, atWidth: width), for: .selected)
        self.setImage(UIImage.init(pdfNamed: imageName.hld, atWidth: width), for: .highlighted)
    }
}
