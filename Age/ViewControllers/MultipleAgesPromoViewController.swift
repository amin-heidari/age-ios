//
//  MultipleAgesPromoViewController.swift
//  Age
//
//  Created by Amin on 2019-07-16.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import StoreKit

class MultipleAgesPromoViewController: BaseViewController {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let localizedPrice = product?.localizedPrice {
            purchaseButton.setTitle("Buy " + localizedPrice, for: .normal)
        }
    }
    
    // MARK: - Properties
    
    private var product: SKProduct? {
        get {
            return StoreManager.shared.availableProducts.first(where: { (product) -> Bool in
                product.productIdentifier == Constants.Store.multipleAgeProductId
            })
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    // MARK: - Methods
    
    @IBAction func purchaseTapped(_ sender: Any) {
        if let p = product {
            StoreObserver.shared.buy(p)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restoreTapped(_ sender: Any) {
        StoreObserver.shared.restore()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Actions

}
