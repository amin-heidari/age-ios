//
//  RingView.swift
//  Age
//
//  Created by Amin on 2019-08-31.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

/// This custom view is only to be used with a 1:1 aspect ratio.
/// Other aspect ratios are not supported.
@IBDesignable class RingView: UIView {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    @IBInspectable var strokeColor: UIColor = .white { didSet { setNeedsDisplay() } }
    @IBInspectable var strokeWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var segmentsCount: Int = 1 { didSet { setNeedsDisplay() } }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let ellipseRect = bounds.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
        let ellipseRadius = ellipseRect.width / 2
        let ellpiseCircumference = 2.0 * CGFloat.pi * ellipseRadius
        
        context.setShouldAntialias(true)
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(strokeWidth)
        
        if (segmentsCount > 1) {
            context.setLineCap(.round)
            
            let paintedLength = ellpiseCircumference / CGFloat(segmentsCount)
            context.setLineDash(
                phase: 0.0,
                lengths: [
                    context.convertToUserSpace(distance: paintedLength)
                ]
            )
        }
        
        context.addEllipse(in: ellipseRect)
//        let ringPath = UIBezierPath(ovalIn: bounds.insetBy(dx: strokeWidth/2, dy: strokeWidth/2))
//        ringPath.lineW
//        ringPath.setLineDash([10.0, 10.0], count: 2, phase: 0.0)
//        context.addPath(ringPath.cgPath)
    
        context.drawPath(using: .stroke)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setNeedsDisplay()
    }
    
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    // MARK: - Actions
    
}
