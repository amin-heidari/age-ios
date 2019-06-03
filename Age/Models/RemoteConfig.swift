//
//  RemoteConfig.swift
//  Age
//
//  Created by Amin on 2019-05-19.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class RemoteConfig: Codable {
    
    class Version: Codable {
        
        enum CompareResult {
            case latestVersion
            case optionalUpgrade
            case forcedUpgrade
        }
        
        func compare(appVersion: String) -> CompareResult {
            if (appVersion.compare(minimum, options: .numeric) == .orderedAscending) {
                return .forcedUpgrade
            } else if (appVersion.compare(latest, options: .numeric) == .orderedAscending) {
                return .optionalUpgrade
            } else {
                return .latestVersion
            }
        }
        
        let minimum: String
        let latest: String
        
        private enum CodingKeys: String, CodingKey {
            case minimum
            case latest
        }
    }
    
    let version: Version
    let storeURL: String
    
    private enum CodingKeys: String, CodingKey {
        case version
        case storeURL = "store_url"
    }
    
}
