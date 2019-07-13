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
    
    private enum Content {
        case noDefaultAge
        case realtimeAge(calculator: AgeCalculator)
        case upgradeOverride(storeUrl: String)
        case openAppOverride
    }
    
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
        
        // Evaluate the content.
        content = evaluateContent()
        
        // Just to be safest.
        timer?.invalidate()
        timer = nil
        
        // Proceed based on the content.
        switch content! {
        case .noDefaultAge:
            ageLabel.text = "No Age!"
        case .realtimeAge:
            timer = Timer.scheduledTimer(timeInterval: Constants.AgeCalculation.refreshInterval,
                                         target: self,
                                         selector: #selector(refreshAge),
                                         userInfo: nil,
                                         repeats: true)
        case .openAppOverride:
            ageLabel.text = "Open app!"
        case .upgradeOverride:
            ageLabel.text = "Upgrade!"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Stop running the updates.
        timer?.invalidate()
        timer = nil
        
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Properties
    
    private var content: Content!
    
    private var timer: Timer?
    
    // MARK: - Outlets
    
    @IBOutlet weak var ageLabel: UILabel!
    
    // MARK: - Methods

    private func evaluateContent() -> Content {
        switch SuiteDefaultsUtil.appWidgetOverride {
        case .upgrade(let storeUrl):
            return .upgradeOverride(storeUrl: storeUrl)
        case .openApp:
            return .openAppOverride
        case .none:
            if let bday = SuiteDefaultsUtil.defaultBirthday {
                return .realtimeAge(calculator: AgeCalculator(birthDate: bday.birthDate))
            } else {
                return .noDefaultAge
            }
        }
    }
    
    @objc private func refreshAge() {
        guard case .realtimeAge(let calculator) = content! else {
            assertionFailure("This should never happen!")
            ageLabel.text = nil
            return
        }
        guard isViewLoaded else { return }
        
        ageLabel.text = String(format: "%.8f", calculator.currentAge.value)
    }
    
    // MARK: - Actions
    
    @IBAction func widgetTapped(_ sender: Any) {
        switch content! {
        case .upgradeOverride(let storeUrl):
            guard let url = URL(string: storeUrl) else { return }
            extensionContext?.open(url, completionHandler: nil)
        default:
            guard let url = URL(string: Constants.URLs.containingAppScheme + "://") else { return }
            extensionContext?.open(url, completionHandler: nil)
        }
    }
    
    
    // MARK: - NCWidgetProviding
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
    }
    
}
