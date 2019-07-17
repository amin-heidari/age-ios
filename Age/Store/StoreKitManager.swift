//
//  StoreKitManager.swift
//  Age
//
//  Created by Amin on 2019-07-14.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation
import StoreKit

class StoreKitManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // Singleton instance.
    static let shared = StoreKitManager()
    
    // MARK: - API
    
    private(set) var productsResult: Either<SKProductsResponse>?

    @discardableResult
    func fetchProducts(completion: @escaping Completion<SKProductsResponse>) -> SKProductsRequest {
        fetchProductsCompletion?(Either.failure(AppError.unknown))
        productsRequest?.cancel()
        let request = SKProductsRequest(productIdentifiers: Set([Constants.InAppPurchase.multipleAgeProductId]))
        request.delegate = self
        productsRequest = request
        fetchProductsCompletion = completion
        request.start()
        return request
    }
    
    func buy(product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // MARK: - Life Cycle
    
    // In order to avoid instances other than `shared` to be created for this type.
    private override init() { }
    
    // MARK: - Properties
    
    private var productsRequest: SKProductsRequest?
    private var fetchProductsCompletion: Completion<SKProductsResponse>?
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    // MARK: - SKProductsRequestDelegate
    
    func requestDidFinish(_ request: SKRequest) { /* No implementation needed for this. */ }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if (productsRequest == request) {
            let result = Either<SKProductsResponse>.failure(error)
            productsResult = result
            DispatchQueue.main.async { self.fetchProductsCompletion?(result) }
            fetchProductsCompletion = nil
            productsRequest = nil
        }
        
        NotificationCenter.default.post(name: .storeKitUpdated, object: nil)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (productsRequest == request) {
            let result = Either.success(response)
            productsResult = result
            DispatchQueue.main.async { self.fetchProductsCompletion?(result) }
            fetchProductsCompletion = nil
            productsRequest = nil
        }
        
        NotificationCenter.default.post(name: .storeKitUpdated, object: nil)
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    // MARK: Handling Transactions
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        guard let txn = transactions.first else { return }
        switch txn.transactionState {
        case .deferred:
            print("deferred")
        case .failed:
            print("failed")
        case .purchased:
            print("purchased")
        case .purchasing:
            print("purchasing")
        case .restored:
            print("restored")
        }
        
        NotificationCenter.default.post(name: .storeKitUpdated, object: nil)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        
        NotificationCenter.default.post(name: .storeKitUpdated, object: nil)
    }
    
    // MARK: Handling Restored Transactions
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        NotificationCenter.default.post(name: .storeKitUpdated, object: nil)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        NotificationCenter.default.post(name: .storeKitUpdated, object: nil)
    }
    
    // MARK: Handling Download Actions
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        
        NotificationCenter.default.post(name: .storeKitUpdated, object: nil)
    }
    
    // MARK: Handling Purchases
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    // MARK:
    
}
