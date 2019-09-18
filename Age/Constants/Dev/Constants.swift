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
        
        /// Time interval (in seconds) during which the cache will be used rather than making a new api call.
        /// If this is lower than the life time of a single application process, then we'll have a re-fetch of the config on each app launch.
        static let freshCacheTime: TimeInterval = 10
        
        /// Time interval (in seconds) after which the cache expires and a fresh remote config MUST be fetched.
        /// Note that, since we don't do a re-fetch in the same app session, this must be much longer than an application process lifetime (in the order of hours if not days).
        static let expireTime: TimeInterval = 60 * 60
    }
    
    class AgeCalculation {
        static let refreshInterval: TimeInterval = 0.01
    }
    
    class UserDefaults {
        static let suiteName = "group.com.aminheidari.Age.dev"
    }
    
    class DeviceIntegrity {
        /// Maximum time the device is allowed to have a time diff from the api.
        static let maxAllowedApiTimeDifference: TimeInterval = 10 * 60
        
        static let hashSaltString = "GDEovBzHY2ljszUsex1U0KBhtXbNfnEP"
    }
    
    class Store {
        static let multipleAgeProductId = "com.aminheidari.Age.dev.multiple"
    }
    
}
