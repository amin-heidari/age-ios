//
//  TodayViewController.swift
//  Widget
//
//  Created by Amin on 2019-07-05.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import NotificationCenter
import AgeData

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the SuiteDefaultsUtil
        SuiteDefaultsUtil.suiteName = Constants.UserDefaults.suiteName
        
        // No expanded mode support for now.
        extensionContext?.widgetLargestAvailableDisplayMode = .compact
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start running the updates.
        guard let bday = birthday else {
            timer?.invalidate()
            timer = nil
            
            ageLabel.text = "TBD"
            
            return
        }
        
        ageCalculator = AgeCalculator(birthDate: bday.birthDate)
        
        timer = Timer.scheduledTimer(timeInterval: Constants.AgeCalculation.refreshInterval,
                                     target: self,
                                     selector: #selector(refreshAge),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Stop running the updates.
        timer?.invalidate()
        timer = nil
        ageCalculator = nil
        
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Properties
    
    private var birthday: Birthday?
    private var ageCalculator: AgeCalculator?
    
    private var timer: Timer?
    
    // MARK: - Outlets
    
    @IBOutlet weak var ageLabel: UILabel!
    
    // MARK: - Methods
    
    @objc private func refreshAge() {
        guard let calculator = ageCalculator, isViewLoaded else {
            return
        }
        
        ageLabel.text = String(format: "%.8f", calculator.currentAge.value)
    }
    
    // MARK: - Actions
    
    // MARK: - NCWidgetProviding
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        // Evaluate the calculator.
        birthday = SuiteDefaultsUtil.defaultBirthday
        
        completionHandler(.newData)
    }
    
}
