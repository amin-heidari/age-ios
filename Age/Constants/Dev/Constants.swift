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
        static let url = "https://dev.api.config.aminheidari.com/projects/age/ios"
        static let apiKeyHeaderField = "X-API-Key"
        static let apiKeyHeaderValue = "dLP8SSrf2h74YvFrqetnM1RnLoU5VcMX820MR2gA"
        static let freshCacheTime: TimeInterval = 1 // Time interval (in seconds) during which the cache will be used rather than making a new api call.
        static let expireTime: TimeInterval = 60 * 10 // Time interval (in seconds) after which the cache expires and a fresh remote config MUST be fetched.
    }
    
    class AgeCalculation {
        static let refreshInterval: TimeInterval = 0.01
    }
    
    class UserDefaults {
        static let suiteName = "group.com.aminheidari.Age.dev"
    }
    
    class DeviceIntegrity {
        // Maximum time the device is allowed to have a time diff from the api.
        static let maxAllowedApiTimeDifference: TimeInterval = 10 * 60
    }
    
    class InAppPurchase {
        static let multipleAgeProductId = "com.aminheidari.Age.dev.multiple"
    }
    
}
