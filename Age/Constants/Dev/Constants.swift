//
//  Constants.swift
//  Age
//
//  Created by Amin on 2019-05-19.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class Constants {
    
    class RemoteConfig {
        static let url = "https://dev.api.config.aminheidari.com/projects/agepal/ios"
        static let apiKeyHeaderField = "X-API-Key"
        static let apiKeyHeaderValue = "dLP8SSrf2h74YvFrqetnM1RnLoU5VcMX820MR2gAkir"
        static let freshCacheTime: TimeInterval = 1 // Time interval (in seconds) during which the cache will be used rather than making a new api call.
        static let expireTime: TimeInterval = 1 * 24 * 3600 // Time interval (in seconds) after which the cache expires and a fresh remote config MUST be fetched.
    }
    
}
