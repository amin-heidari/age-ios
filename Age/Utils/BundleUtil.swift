//
//  BundleUtil.swift
//  Age
//
//  Created by Amin on 2019-06-02.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

extension Bundle {
    
    var buildNumber: String {
        return self.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    
    var versionNumber: String {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
}
