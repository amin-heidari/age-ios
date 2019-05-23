//
//  UserDefaultsUtil.swift
//  Age
//
//  Created by Amin on 2019-04-21.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class UserDefaultsUtil {
    
    enum Keys: String {
        case DefaultBirthday
        case CachedRemoteConfig
    }
    
    static let shared = UserDefaultsUtil()
    
    // https://fluffy.es/saving-custom-object-into-userdefaults/
    var defaultBirthday: Birthday? {
        get {
            guard let data = UserDefaults.standard.object(forKey: Keys.DefaultBirthday.rawValue) as? Data,
                let birthday = try? PropertyListDecoder().decode(Birthday.self, from: data) else { return nil }
            return birthday
        }
        set(newValue){
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: Keys.DefaultBirthday.rawValue)
        }
    }
    
}
