//
//  StoreObserver.swift
//  Age
//
//  Created by Amin on 2019-07-16.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

import StoreKit
import Foundation

class StoreObserver: NSObject {
    
    // MARK: - Types
    
    /// A structure of messages that will be displayed to users.
    struct Messages {
        #if os (iOS)
        static let cannotMakePayments = "\(notAuthorized) \(installing)"
        #else
        static let cannotMakePayments = "In-App Purchases are not allowed."
        #endif
        static let couldNotFind = "Could not find resource file:"
        static let deferred = "Allow the user to continue using your app."
        static let deliverContent = "Deliver content for"
        static let emptyString = ""
        static let error = "Error: "
        static let failed = "failed."
        static let installing = "In-App Purchases may be restricted on your device."
        static let invalidIndexPath = "Invalid selected index path"
        static let noRestorablePurchases = "There are no restorable purchases.\n\(previouslyBought)"
        static let noPurchasesAvailable = "No purchases available."
        static let notAuthorized = "You are not authorized to make payments."
        static let okButton = "OK"
        static let previouslyBought = "Only previously bought non-consumable products and auto-renewable subscriptions can be restored."
        static let productRequestStatus = "Product Request Status"
        static let purchaseOf = "Purchase of"
        static let purchaseStatus = "Purchase Status"
        static let removed = "was removed from the payment queue."
        static let restorable = "All restorable transactions have been processed by the payment queue."
        static let restoreContent = "Restore content for"
        static let status = "Status"
        static let unableToInstantiateAvailableProducts = "Unable to instantiate an AvailableProducts."
        static let unableToInstantiateInvalidProductIds = "Unable to instantiate an InvalidProductIdentifiers."
        static let unableToInstantiateMessages = "Unable to instantiate a MessagesViewController."
        static let unableToInstantiateNavigationController = "Unable to instantiate a navigation controller."
        static let unableToInstantiateProducts = "Unable to instantiate a Products."
        static let unableToInstantiatePurchases = "Unable to instantiate a Purchases."
        static let unableToInstantiateSettings = "Unable to instantiate a Settings."
        static let unknownDefault = "Unknown payment transaction case."
        static let unknownDestinationViewController = "Unknown destination view controller."
        static let unknownDetail = "Unknown detail row:"
        static let unknownPurchase = "No selected purchase."
        static let unknownSelectedSegmentIndex = "Unknown selected segment index: "
        static let unknownSelectedViewController = "Unknown selected view controller."
        static let unknownTabBarIndex = "Unknown tab bar index:"
        static let unknownToolbarItem = "Unknown selected toolbar item: "
        static let updateResource = "Update it with your product identifiers to retrieve product information."
        static let useStoreRestore = "Use Store > Restore to restore your previously bought non-consumable products and auto-renewable subscriptions."
        static let viewControllerDoesNotExist = "The main content view controller does not exist."
        static let windowDoesNotExist = "The window does not exist."
    }
    
    static let shared = StoreObserver()
    
    // MARK: - Properties
    
    /**
     Indicates whether the user is allowed to make payments.
     - returns: true if the user is allowed to make payments and false, otherwise. Tell StoreManager to query the App Store when the user is
     allowed to make payments and there are product identifiers to be queried.
     */
    var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    /// Keeps track of all purchases.
    private(set) var purchased = [SKPaymentTransaction]()
    
    /// Keeps track of all restored purchases.
    private(set) var restored = [SKPaymentTransaction]()
    
    /// Indicates whether there are restorable purchases.
    fileprivate var hasRestorablePurchases = false
    
    weak var delegate: StoreObserverDelegate?
    
    // MARK: - Initializer
    
    private override init() {}
    
    // MARK: - Submit Payment Request
    
    /// Create and add a payment request to the payment queue.
    func buy(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - Restore All Restorable Purchases
    
    /// Restores all previously completed purchases.
    func restore() {
        if !restored.isEmpty {
            restored.removeAll()
        }
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Handle Payment Transactions
    
    /// Handles successful purchase transactions.
    fileprivate func handlePurchased(_ transaction: SKPaymentTransaction) {
        purchased.append(transaction)
        print("\(Messages.deliverContent) \(transaction.payment.productIdentifier).")
        
        // Finish the successful transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /// Handles failed purchase transactions.
    fileprivate func handleFailed(_ transaction: SKPaymentTransaction) {
        var message = "\(Messages.purchaseOf) \(transaction.payment.productIdentifier) \(Messages.failed)"
        
        if let error = transaction.error {
            message += "\n\(Messages.error) \(error.localizedDescription)"
            print("\(Messages.error) \(error.localizedDescription)")
        }
        
        // Do not send any notifications when the user cancels the purchase.
        if (transaction.error as? SKError)?.code != .paymentCancelled {
            DispatchQueue.main.async {
                self.delegate?.storeObserverDidReceiveMessage(message)
            }
        }
        // Finish the failed transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /// Handles restored purchase transactions.
    fileprivate func handleRestored(_ transaction: SKPaymentTransaction) {
        hasRestorablePurchases = true
        restored.append(transaction)
        print("\(Messages.restoreContent) \(transaction.payment.productIdentifier).")
        
        DispatchQueue.main.async {
            self.delegate?.storeObserverRestoreDidSucceed()
        }
        // Finishes the restored transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

// MARK: - SKPaymentTransactionObserver

/// Extends StoreObserver to conform to SKPaymentTransactionObserver.
extension StoreObserver: SKPaymentTransactionObserver {
    /// Called when there are transactions in the payment queue.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing: break
            // Do not block your UI. Allow the user to continue using your app.
            case .deferred: print(Messages.deferred)
            // The purchase was successful.
            case .purchased: handlePurchased(transaction)
            // The transaction failed.
            case .failed: handleFailed(transaction)
            // There are restored products.
            case .restored: handleRestored(transaction)
            @unknown default: fatalError("\(Messages.unknownDefault)")
            }
        }
        self.delegate?.storeObserverTransactionsStateUpdated()
    }
    
    /// Logs all transactions that have been removed from the payment queue.
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print ("\(transaction.payment.productIdentifier) \(Messages.removed)")
            self.delegate?.storeObserverTransactionsStateUpdated()
        }
    }
    
    /// Called when an error occur while restoring purchases. Notify the user about the error.
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError, error.code != .paymentCancelled {
            DispatchQueue.main.async {
                self.delegate?.storeObserverDidReceiveMessage(error.localizedDescription)
                self.delegate?.storeObserverTransactionsStateUpdated()
            }
        }
    }
    
    /// Called when all restorable transactions have been processed by the payment queue.
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print(Messages.restorable)
        
        if !hasRestorablePurchases {
            DispatchQueue.main.async {
                self.delegate?.storeObserverDidReceiveMessage(Messages.noRestorablePurchases)
                self.delegate?.storeObserverTransactionsStateUpdated()
            }
        }
    }
}


