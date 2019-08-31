//
//  GradientView.swift
//  Age
//
//  Created by Amin on 2019-08-29.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    // MARK: - Properties
    
    /// Simply shadowing the view's layer.
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    @IBInspectable var startColor: UIColor = .red { didSet { setNeedsLayout() } }
    @IBInspectable var endColor: UIColor = .blue { didSet { setNeedsLayout() } }
    
    @IBInspectable var shadowColor: UIColor = .clear { didSet { setNeedsLayout() } }
    @IBInspectable var shadowX: CGFloat = 0 { didSet { setNeedsLayout() } }
    @IBInspectable var shadowY: CGFloat = -3 { didSet { setNeedsLayout() } }
    @IBInspectable var shadowBlur: CGFloat = 3 { didSet { setNeedsLayout() } }
    
    @IBInspectable var startPointX: CGFloat = 0 { didSet { setNeedsLayout() } }
    @IBInspectable var startPointY: CGFloat = 0.5 { didSet { setNeedsLayout() } }
    @IBInspectable var endPointX: CGFloat = 1 { didSet { setNeedsLayout() } }
    @IBInspectable var endPointY: CGFloat = 0.5 { didSet { setNeedsLayout() } }
    
    @IBInspectable var cornerRadius: CGFloat = 0 { didSet { setNeedsLayout() } }
    
    override func layoutSubviews() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        layer.shadowRadius = shadowBlur
        layer.shadowOpacity = 1
    }
    
    /* Will use this animation feature later if/when needed.
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        gradientLayer?.add(animation, forKey:"animateGradient")
    } */
}
