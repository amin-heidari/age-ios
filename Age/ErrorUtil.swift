//
//  ErrorUtil.swift
//  Age
//
//  Created by Amin on 2019-05-23.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

extension Error {
    
    var code: Int { return (self as NSError).code }
    
}
