//
//  StoreManager.swift
//  Age
//
//  Created by Amin on 2019-07-16.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import StoreKit
import Foundation

class StoreManager: NSObject {
    
    // MARK: - Types
    
    /// An enumeration of all the types of products or purchases.
    enum SectionType: String, CustomStringConvertible {
        case availableProducts = "AVAILABLE PRODUCTS"
        case invalidProductIdentifiers = "INVALID PRODUCT IDENTIFIERS"
        case purchased = "PURCHASED"
        case restored = "RESTORED"
        case download = "DOWNLOAD"
        case originalTransaction = "ORIGINAL TRANSACTION"
        case productIdentifier = "PRODUCT IDENTIFIER"
        case transactionDate = "TRANSACTION DATE"
        case transactionIdentifier = "TRANSACTION ID"
        
        var description: String {
            return self.rawValue
        }
    }
    
    /// A structure that is used to represent a list of products or purchases.
    struct Section {
        /// Products/Purchases are organized by category.
        var type: SectionType
        /// List of products/purchases.
        var elements = [Any]()
    }
    
    static let shared = StoreManager()
    
    // MARK: - Properties
    
    /// Keeps track of all valid products. These products are available for sale in the App Store.
    fileprivate(set) var availableProducts = [SKProduct]()
    
    /// Keeps track of all invalid product identifiers.
    fileprivate(set) var invalidProductIdentifiers = [String]()
    
    /// Keeps a strong reference to the product request.
    fileprivate(set) var productRequest: SKProductsRequest!
    
    /// Keeps track of all valid products (these products are available for sale in the App Store) and of all invalid product identifiers.
    fileprivate(set) var storeResponse = [Section]()
    
    weak var delegate: StoreManagerDelegate?
    
    // MARK: - Initializer
    
    private override init() {}
    
    // MARK: - Request Product Information
    
    /// Starts the product request with the specified identifiers.
    func startProductRequest(with identifiers: [String]) {
        fetchProducts(matchingIdentifiers: identifiers)
    }
    
    /// Fetches information about your products from the App Store.
    /// - Tag: FetchProductInformation
    fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)
        
        // Initialize the product request with the above identifiers.
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        
        // Send the request to the App Store.
        productRequest.start()
    }
    
    // MARK: - Helper Methods
    
    /// - returns: Existing product's title matching the specified product identifier.
    func title(matchingIdentifier identifier: String) -> String? {
        var title: String?
        guard !availableProducts.isEmpty else { return nil }
        
        // Search availableProducts for a product whose productIdentifier property matches identifier. Return its localized title when found.
        let result = availableProducts.filter({ (product: SKProduct) in product.productIdentifier == identifier })
        
        if !result.isEmpty {
            title = result.first!.localizedTitle
        }
        return title
    }
    
    /// - returns: Existing product's title associated with the specified payment transaction.
    func title(matchingPaymentTransaction transaction: SKPaymentTransaction) -> String {
        let title = self.title(matchingIdentifier: transaction.payment.productIdentifier)
        return title ?? transaction.payment.productIdentifier
    }
}

// MARK: - SKProductsRequestDelegate

/// Extends StoreManager to conform to SKProductsRequestDelegate.
extension StoreManager: SKProductsRequestDelegate {
    /// Used to get the App Store's response to your request and notify your observer.
    /// - Tag: ProductRequest
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !storeResponse.isEmpty {
            storeResponse.removeAll()
        }
        
        // products contains products whose identifiers have been recognized by the App Store. As such, they can be purchased.
        if !response.products.isEmpty {
            availableProducts = response.products
            storeResponse.append(Section(type: .availableProducts, elements: availableProducts))
        }
        
        // invalidProductIdentifiers contains all product identifiers not recognized by the App Store.
        if !response.invalidProductIdentifiers.isEmpty {
            invalidProductIdentifiers = response.invalidProductIdentifiers
            storeResponse.append(Section(type: .invalidProductIdentifiers, elements: invalidProductIdentifiers))
        }
        
        if !storeResponse.isEmpty {
            DispatchQueue.main.async {
                self.delegate?.storeManagerDidReceiveResponse(self.storeResponse)
            }
        }
    }
}

// MARK: - SKRequestDelegate

/// Extends StoreManager to conform to SKRequestDelegate.
extension StoreManager: SKRequestDelegate {
    /// Called when the product request failed.
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.storeManagerDidReceiveMessage(error.localizedDescription)
        }
    }
}

