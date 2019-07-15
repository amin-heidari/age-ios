//
//  StoreKitManager.swift
//  Age
//
//  Created by Amin on 2019-07-14.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation
import StoreKit

class StoreKitManager: NSObject {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // Singleton instance.
    static let shared = StoreKitManager()
    
    // MARK: - API

    func fetchProducts(completion: Completion<Unit>) {
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: Set(Constants.InAppPurchase.multipleAgeProductId))
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    // MARK: - Life Cycle
    
    // In order to avoid instances other than `shared` to be created for this type.
    private override init() { }
    
    // MARK: - Properties
    
    private var productsRequest: SKProductsRequest?
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    // MARK: - Delegate
    
    // MARK: - Delegate
    
}
