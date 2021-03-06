//
//  SuiteDefaultsUtil.swift
//  AgeData
//
//  Created by Amin on 2019-07-05.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

public class SuiteDefaultsUtil {
    
    // MARK: - Constants/Types
    
    private enum Keys: String {
        case defaultBirthday
        case appWidgetOverride
    }
    
    // MARK: - API
    
    public static var suiteName: String = "" {
        didSet {
            suiteUserDefaults = UserDefaults(suiteName: suiteName)
        }
    }
    
    public static var defaultBirthday: Birthday? {
        get {
            guard let data = suiteUserDefaults.object(forKey: Keys.defaultBirthday.rawValue) as? Data,
                let birthday = try? PropertyListDecoder().decode(Birthday.self, from: data) else { return nil }
            return birthday
        }
        set(newValue){
            suiteUserDefaults.set(try? PropertyListEncoder().encode(newValue), forKey: Keys.defaultBirthday.rawValue)
        }
    }
    
    public static var appWidgetOverride: AppWidgetOverride {
        get {
            guard let data = suiteUserDefaults.object(forKey: Keys.appWidgetOverride.rawValue) as? Data,
                let override = try? PropertyListDecoder().decode(AppWidgetOverride.self, from: data) else { return .none }
            return override
        }
        set(newValue){
            suiteUserDefaults.set(try? PropertyListEncoder().encode(newValue), forKey: Keys.appWidgetOverride.rawValue)
        }
    }
    
    // MARK: - Properties
    
    private static var suiteUserDefaults: UserDefaults!
}
