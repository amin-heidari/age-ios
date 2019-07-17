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
        static let url = "https://api.config.aminheidari.com/projects/age/ios"
        static let apiKeyHeaderField = "X-API-Key"
        static let apiKeyHeaderValue = "TBD"
        static let freshCacheTime: TimeInterval = 30 // Time interval (in seconds) during which the cache will be used rather than making a new api call.
        static let expireTime: TimeInterval = 7 * 24 * 3600 // Time interval (in seconds) after which the cache expires and a fresh remote config MUST be fetched.
    }
    
    class AgeCalculation {
        static let refreshInterval: TimeInterval = 0.01
    }
    
    class UserDefaults {
        static let suiteName = "group.com.aminheidari.Age"
    }
    
    class DeviceIntegrity {
        static let maxAllowedApiTimeDifference: TimeInterval = 10 * 60 // Maximum time the device is allowed to have a time diff from the api.
    }
    
    class Store {
        static let multipleAgeProductId = "com.aminheidari.Age.multiple"
    }
    
}
