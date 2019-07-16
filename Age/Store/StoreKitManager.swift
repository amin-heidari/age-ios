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
    
    private(set) var productsResponse: SKProductsResponse?

    func fetchProducts(completion: @escaping Completion<SKProductsResponse>) {
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: Set([Constants.InAppPurchase.multipleAgeProductId]))
        productsRequest?.delegate = self
        fetchProductsCompletion = completion
        productsRequest?.start()
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
    
    func requestDidFinish(_ request: SKRequest) { }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if (productsRequest == request) {
            fetchProductsCompletion?(Either.failure(error))
            fetchProductsCompletion = nil
            productsRequest = nil
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (productsRequest == request) {
            productsResponse = response
            fetchProductsCompletion?(Either.success(response))
            fetchProductsCompletion = nil
            productsRequest = nil
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        transactions.first!.transactionState == .
    }
    
}
