//
//  UserDefaultsUtil.swift
//  Age
//
//  Created by Amin on 2019-04-21.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

// https://fluffy.es/saving-custom-object-into-userdefaults/
class UserDefaultsUtil {
    
    // MARK: - Constants/Types
    
    private enum Keys: String {
        case defaultBirthday
        case cachedRemoteConfig
        case skippedLatestVersion // The version which was skipped.
    }
    
    // MARK: - API
    
    static var defaultBirthday: Birthday? {
        get {
            guard let data = UserDefaults.standard.object(forKey: Keys.defaultBirthday.rawValue) as? Data,
                let birthday = try? PropertyListDecoder().decode(Birthday.self, from: data) else { return nil }
            return birthday
        }
        set(newValue){
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: Keys.defaultBirthday.rawValue)
        }
    }
    
    /// To be accessed only by the private computed property `cachedRemoteConfig`, of `RemoteConfigManager`.
    static var cachedRemoteConfig: RemoteConfigManager.CachedRemoteConfig? {
        get {
            guard let data = UserDefaults.standard.object(forKey: Keys.cachedRemoteConfig.rawValue) as? Data,
                let cachedRemoteConfig = try? PropertyListDecoder().decode(RemoteConfigManager.CachedRemoteConfig.self, from: data) else { return nil }
            return cachedRemoteConfig
        }
        set(newValue){
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: Keys.cachedRemoteConfig.rawValue)
        }
    }
    
    static var skippedLatestVersion: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.skippedLatestVersion.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.skippedLatestVersion.rawValue)
        }
    }
    
}
