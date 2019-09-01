//
//  CoreGraphicsUtil.swift
//  Age
//
//  Created by Amin on 2019-08-31.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

extension CGContext {
    
    func convertToUserSpace(distance: CGFloat) -> CGFloat {
        return convertToUserSpace(CGSize(width: distance, height: distance)).width
    }
    
    func convertToDeviceSpace(distance: CGFloat) -> CGFloat {
        return convertToDeviceSpace(CGSize(width: distance, height: distance)).width
    }
    
}
