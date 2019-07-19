//
//  MultipleAgesPromoViewController.swift
//  Age
//
//  Created by Amin on 2019-07-16.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class MultipleAgesPromoViewController: BaseViewController {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Methods
    
    @IBAction func purchaseTapped(_ sender: Any) {
        if let product = StoreManager.shared.availableProducts.first(where: { (product) -> Bool in
            product.productIdentifier == Constants.Store.multipleAgeProductId
        }) {
            StoreObserver.shared.buy(product)
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
