//
//  StoreKitUtil.swift
//  Age
//
//  Created by Amin on 2019-07-14.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    
    /// - returns: The cost of the product formatted in the local currency.
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
    
}
