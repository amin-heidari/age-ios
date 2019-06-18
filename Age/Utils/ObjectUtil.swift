//
//  ObjectUtil.swift
//  Age
//
//  Created by Amin on 2019-06-17.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

extension AnyObject {
    
    var uniqueId: String {
        return String(UInt(bitPattern: ObjectIdentifier(self)))
    }
    
}
