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

enum SKProductStatus {
    case pending
    case purhcased
    case restored
    case unknown
}

extension StoreObserver {
    
    func productStatus(forProductId productId: String) -> SKProductStatus {
        if purchased.contains(where: { (transaction) -> Bool in
            transaction.payment.productIdentifier == productId
        }) { return .purhcased }
        
        if restored.contains(where: { (transaction) -> Bool in
            transaction.payment.productIdentifier == productId
        }) { return .restored }
        
        if SKPaymentQueue.default().transactions.contains(where: { (transaction) -> Bool in
            transaction.payment.productIdentifier == productId
        }) { return .pending }
        
        return .unknown
    }
    
}

// MARK: - StoreManagerDelegate

protocol StoreManagerDelegate: AnyObject {
    /// Provides the delegate with the App Store's response.
    func storeManagerDidReceiveResponse(_ response: [StoreManager.Section])
    
    /// Provides the delegate with the error encountered during the product request.
    func storeManagerDidReceiveMessage(_ message: String)
}

// MARK: - StoreObserverDelegate

protocol StoreObserverDelegate: AnyObject {
    /// Tells the delegate that the restore operation was successful.
    func storeObserverRestoreDidSucceed()
    
    /// Provides the delegate with messages.
    func storeObserverDidReceiveMessage(_ message: String)
    
    /// Fired when any transaction state update happens.
    func storeObserverTransactionsStateUpdated()
}
