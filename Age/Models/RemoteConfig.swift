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
    
    class AgeSpecs: Codable {
        // Default age shown when launching the app on the date picker, in terms of years.
        let defaultAge: Int
        // Max allowable age (to be picked initially), in terms of years.
        let maxAge: Int
        
        private enum CodingKeys: String, CodingKey {
            case defaultAge = "default_age"
            case maxAge = "max_age"
        }
    }
    
    class AgesCard: Codable {
        // Default age shown when launching the app on the date picker, in terms of years.
        let startColor: String
        // Max allowable age (to be picked initially), in terms of years.
        let endColor: String
        
        private enum CodingKeys: String, CodingKey {
            case startColor = "start_color"
            case endColor = "end_color"
        }
    }
    
    let storeURL: String
    let version: Version
    let ageSpecs: AgeSpecs
    let agesCards: [AgesCard]
    
    private enum CodingKeys: String, CodingKey {
        case storeURL = "store_url"
        case version
        case ageSpecs = "age_specs"
        case agesCards = "ages_cards"
    }
    
}
