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
    
    private enum Key: String {
        case defaultBirthday
        case cachedRemoteConfig
        case skippedLatestVersion // The version which was skipped.
        case multipleAgesIAPTransactionIdentifier
        case cachedMonitorRate // Hash for `multipleAgesIAPTransactionIdentifier`
    }
    
    // MARK: - API
    
    /// To be accessed only by the private computed property `cachedRemoteConfig`, of `RemoteConfigManager`.
    static var cachedRemoteConfig: RemoteConfigManager.CachedRemoteConfig? {
        get {
            guard let data = UserDefaults.standard.object(forKey: Key.cachedRemoteConfig.rawValue) as? Data,
                let cachedRemoteConfig = try? PropertyListDecoder().decode(RemoteConfigManager.CachedRemoteConfig.self, from: data) else { return nil }
            return cachedRemoteConfig
        }
        set(newValue){
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: Key.cachedRemoteConfig.rawValue)
        }
    }
    
    /// The latestVersion which has been skipped at the moment.
    /// For example, user may have skipped upgrade to the latestVersion of 2.2.0 (and `2.2.0` will be persisted here),
    /// however, when the latestVersion on the store turns out to be `2.3.0`,
    /// then we'll know that we haven't presented that to the user yet.
    static var skippedLatestVersion: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.skippedLatestVersion.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Key.skippedLatestVersion.rawValue)
        }
    }
    
    /// The transaction identifier for the mutliple ages IAP.
    /// Integrity protected through salt-hashing with a secret salt.
    static var multipleAgesIAPTransactionIdentifier: String? {
        get {
            return getProtectedString(
                originalKey: Key.multipleAgesIAPTransactionIdentifier,
                hashKey: Key.cachedMonitorRate,
                defaultValue: nil
            )
        }
        set(newValue) {
            setProtectedString(
                originalKey: Key.multipleAgesIAPTransactionIdentifier,
                hashKey: Key.cachedMonitorRate,
                newValue: newValue
            )
        }
    }
    
    // MARK: - Methods
    
    private static func getProtectedString(originalKey: Key, hashKey: Key, defaultValue: String?) -> String? {
        if let value = UserDefaults.standard.string(forKey: originalKey.rawValue) {
            let expectedHash = String(format: "%s%s", value, Constants.DeviceIntegrity.hashSaltString).data(using: .utf8)!.sha512.raw
            if let saltedHash = UserDefaults.standard.string(forKey: hashKey.rawValue), saltedHash == expectedHash {
                return value
            } else {
                UserDefaults.standard.set(nil, forKey: originalKey.rawValue)
                UserDefaults.standard.set(nil, forKey: hashKey.rawValue)
                return nil
            }
        } else {
            return nil
        }
    }
    
    private static func setProtectedString(originalKey: Key, hashKey: Key, newValue: String?) {
        guard let newVal = newValue else {
            UserDefaults.standard.set(nil, forKey: originalKey.rawValue)
            UserDefaults.standard.set(nil, forKey: hashKey.rawValue)
            return
        }
        // Evaluate the salted-hash.
        let saltedHash = String(format: "%s%s", newVal, Constants.DeviceIntegrity.hashSaltString).data(using: .utf8)!.sha512.raw
        // Persist the data and its hash.
        UserDefaults.standard.set(newVal, forKey: originalKey.rawValue)
        UserDefaults.standard.set(saltedHash, forKey: hashKey.rawValue)
    }
    
}
