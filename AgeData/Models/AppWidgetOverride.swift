//
//  AppWidgetOverride.swift
//  AgeData
//
//  Created by Amin on 2019-07-07.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

/// Used by the containing app if it needs to override the behaviour of the widget.
public enum AppWidgetOverride: Codable {
    /// The containing app does not want to override the behaviour of the widget in any way.
    /// The widget should continue it's normal behaviour.
    case none
    /// The containing app needs the widget to open the app to figure things out and continue.
    /// In the meantime, the widget should obey this.
    case openApp
    /// The containing app has found out that there's an upgrade available on the store.
    /// The widget needs to upgrade the app using the give `storeUrl`, and open the app to settle things and proceed.
    case upgrade(storeUrl: String)
    
    // https://dmtopolog.com/serialisation-of-enum-with-associated-type/
    enum CodingKeys: CodingKey {
        case none
        case openApp
        case upgradeStoreUrl
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .none:
            try container.encode(true, forKey: .none)
        case .openApp:
            try container.encode(true, forKey: .openApp)
        case .upgrade(let storeUrl):
            try container.encode(storeUrl, forKey: .upgradeStoreUrl)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let _ = try? values.decode(Bool.self, forKey: .none) {
            self = .none
        } else if let _ = try? values.decode(Bool.self, forKey: .openApp) {
            self = .openApp
        } else if let upgradeStoreUrl = try? values.decode(String.self, forKey: .upgradeStoreUrl) {
            self = .upgrade(storeUrl: upgradeStoreUrl)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        }
    }
}
