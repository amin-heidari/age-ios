//
//  ScalingButton.swift
//  Age
//
//  Created by Amin on 2019-08-31.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

/// https://blog.supereasyapps.com/how-to-create-round-buttons-using-ibdesignable-on-ios-11/
@IBDesignable
class ScalingButton: UIButton {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    @IBInspectable var startColor: UIColor = .white { didSet { setNeedsLayout() } }
    @IBInspectable var endColor: UIColor = .white { didSet { setNeedsLayout() } }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        sharedInit()
        setup()
    }
    
    private func sharedInit() {
        gradientBackgroundLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientBackgroundLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientBackgroundLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    // MARK: - Properties
    
    private let gradientBackgroundLayer: CAGradientLayer = CAGradientLayer()
    
    override var isHighlighted: Bool {
        willSet(newValue) {
            super.isHighlighted = newValue
            
            if (newValue) {
                UIView.animate(withDuration: 0.06) { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                }
            } else {
                UIView.animate(withDuration: 0.08) { [weak self] in
                    self?.transform = .identity
                }
            }
        }
    }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    private func setup() {
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
        
        gradientBackgroundLayer.frame = layer.bounds
        gradientBackgroundLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    // MARK: - Actions

}
