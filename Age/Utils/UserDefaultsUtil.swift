//
//  UserDefaultsUtil.swift
//  Age
//
//  Created by Amin on 2019-04-21.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation
import AgeData

// https://fluffy.es/saving-custom-object-into-userdefaults/
class UserDefaultsUtil {
    
    // MARK: - Constants/Types
    
    private enum Keys: String {
        case defaultBirthday
        case cachedRemoteConfig
        case skippedLatestVersion // The version which was skipped.
    }
    
    // MARK: - API
    
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
    
    /// The latestVersion which has been skipped at the moment.
    /// For example, user may have skipped upgrade to the latestVersion of 2.2.0 (and `2.2.0` will be persisted here),
    /// however, when the latestVersion on the store turns out to be `2.3.0`,
    /// then we'll know that we haven't presented that to the user yet.
    static var skippedLatestVersion: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.skippedLatestVersion.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.skippedLatestVersion.rawValue)
        }
    }
    
}
