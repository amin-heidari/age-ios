//
//  AgeViewController.swift
//  Age
//
//  Created by Amin on 2019-05-23.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import AgeData

class AgeViewController: BaseViewController, StoreManagerDelegate {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreManager.shared.delegate = self
        StoreManager.shared.startProductRequest(with: [Constants.Store.multipleAgeProductId])
        
        if let _ = UserDefaultsUtil.multipleAgesIAPTransactionId {
            agesButton.isHidden = false
        }
        
        // Setting these in code here since the IB doesn't respond well to these color asset changes.
        backgroundGradientView.startColor = .primary
        backgroundGradientView.endColor = .accent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ageCalculator = AgeCalculator(birthDate: SuiteDefaultsUtil.defaultBirthday!.birthDate)
        
        timer = Timer.scheduledTimer(timeInterval: Constants.AgeCalculation.refreshInterval,
                                     target: self,
                                     selector: #selector(refreshAge),
                                     userInfo: nil,
                                     repeats: true)
        
        startGaugeAnimations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        ageCalculator = nil
        
        // Remove the gauge layers animations.
        stopGaugeAnimations()
        
        super.viewDidDisappear(animated)
    }
    
    override func applicationWillEnterForeground() {
        super.applicationWillEnterForeground()
        
        startGaugeAnimations()
    }
    
    override func applicationDidEnterBackground() {
        super.applicationDidEnterBackground()
        
        stopGaugeAnimations()
    }
    
    // MARK: - Properties
    
    override var isNavigationBarHidden: Bool { return true }
    override var appStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var ageCalculator: AgeCalculator?
    private var timer: Timer?
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundGradientView: GradientView!
    
    @IBOutlet private weak var ageLabel: UILabel!
    
    @IBOutlet private weak var agesButton: UIButton!
    
    @IBOutlet weak var gaugeView: UIView!
    @IBOutlet weak var ringView1: RingView!
    @IBOutlet weak var ringView2: RingView!
    @IBOutlet weak var ringView3: RingView!
    
    // MARK: - Methods
    
    @objc private func refreshAge() {
        guard let calculator = ageCalculator, isViewLoaded, let _ = view.window else {
            return
        }
        
        ageLabel.text = String(format: "%.8f", calculator.currentAge.value)
    }
    
    private func startGaugeAnimations() {
        guard (isViewLoaded) else {
            ringView1.layer.removeAllAnimations()
            ringView3.layer.removeAllAnimations()
            return
        }
        
        ringView1.layer.removeAllAnimations()
        let largeRotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        largeRotationAnimation.fromValue = 0.0
        largeRotationAnimation.toValue = -Double.pi * 2.0
        largeRotationAnimation.duration = 80.0
        largeRotationAnimation.repeatCount = .infinity
        ringView1.layer.add(largeRotationAnimation, forKey: nil)
        
        ringView3.layer.removeAllAnimations()
        let smallRotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        smallRotationAnimation.fromValue = 0.0
        smallRotationAnimation.toValue = Double.pi * 2.0
        smallRotationAnimation.duration = 40.0
        smallRotationAnimation.repeatCount = .infinity
        ringView3.layer.add(smallRotationAnimation, forKey: nil)
    }
    
    private func stopGaugeAnimations() {
        ringView1.layer.removeAllAnimations()
        ringView3.layer.removeAllAnimations()
    }
    
    // MARK: - Actions
    
    @IBAction func agesButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ages", sender: nil)
    }
    
    // MARK: - StoreManagerDelegate
    
    func storeManagerDidReceiveMessage(_ message: String) { }
    
    func storeManagerDidReceiveResponse(_ response: [StoreManager.Section]) {
        if (UserDefaultsUtil.multipleAgesIAPTransactionId == nil) {
            if StoreManager.shared.availableProducts.contains(where: { (product) -> Bool in
                product.productIdentifier == Constants.Store.multipleAgeProductId
            }) && StoreObserver.shared.isAuthorizedForPayments {
                agesButton.isHidden = false
            } else {
                agesButton.isHidden = true
            }
        }
    }
    
}
