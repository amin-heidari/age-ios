//
//  LoadingViewController.swift
//  Age
//
//  Created by Amin on 2019-05-20.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import AgeData

class LoadingViewController: BaseViewController {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadConfig()
    }
    
    deinit {
        configTask?.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewAgeViewController {
            destination.scenario = .newDefault
        }
    }
    
    // MARK: - Properties
    
    override var isNavigationBarHidden: Bool { return true }
    
    private var configTask: URLSessionTask?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorStackView: UIStackView!
    
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var errorImageView: UIImageView!
    @IBOutlet private weak var errorDescriptionLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    
    // MARK: - Methods
    
    private func loadConfig() {
        activityIndicator.isHidden = false
        errorStackView.isHidden = true
        
        configTask?.cancel()
        configTask = RemoteConfigManager.shared.fetchConfig { [weak self] (result) in
            guard let `self` = self else { return }
            
            self.activityIndicator.isHidden = true
            
            switch result {
            case .failure(let error):
                self.errorStackView.isHidden = false
                
                switch error {
                case AppError.connection:
                    // Not connected to the internet.
                    self.errorTitleLabel.text = "No Internet!"
                    self.errorImageView.image = #imageLiteral(resourceName: "no_internet")
                    self.errorDescriptionLabel.text = "It looks like you're not connected to the internet. Please connect and try again!"
                    self.retryButton.isHidden = false
                    
                    SuiteDefaultsUtil.appWidgetOverride = .openApp
                    
                case AppError.certificateExpired:
                    // Please udpate the app.
                    self.errorTitleLabel.text = "Please upgrade!"
                    self.errorImageView.image = #imageLiteral(resourceName: "sad_face")
                    self.errorDescriptionLabel.text = "Please upgrade the application to the latest version in order to continue."
                    self.retryButton.isHidden = true
                    
                    SuiteDefaultsUtil.appWidgetOverride = .openApp
                    
                default:
                    // Generic message.
                    self.errorTitleLabel.text = "Error!"
                    self.errorImageView.image = #imageLiteral(resourceName: "sad_face")
                    self.errorDescriptionLabel.text = "An unknown error occurred. Please try again later!"
                    self.retryButton.isHidden = false
                    
                    SuiteDefaultsUtil.appWidgetOverride = .openApp
                }
            case .success(let remoteConfig):
                self.errorStackView.isHidden = true
                
                switch remoteConfig.version.compare(appVersion: Bundle.main.versionNumber) {
                case .forcedUpgrade:
                    // The app's version is below the minimum required version.
                    
                    SuiteDefaultsUtil.appWidgetOverride = .upgrade(storeUrl: remoteConfig.storeURL)
                    
                    self.performSegue(withIdentifier: "upgrade", sender: nil)
                    
                case .optionalUpgrade:
                    // The app's version is below the latest version.
                    
                    SuiteDefaultsUtil.appWidgetOverride = .none
                    
                    if let skippedVersion = UserDefaultsUtil.skippedLatestVersion, skippedVersion.compare(remoteConfig.version.latest, options: .numeric) != .orderedAscending {
                        // User has already skipped to upgrade to that version before.
                        self.proceedToTheApp()
                    } else {
                        // User has never skipped an upgrade to this version.
                        self.performSegue(withIdentifier: "upgrade", sender: nil)
                    }
                case .latestVersion:
                    SuiteDefaultsUtil.appWidgetOverride = .none
                    
                    self.proceedToTheApp()
                }
            }
        }
    }
    
    private func proceedToTheApp() {
        if let _ = SuiteDefaultsUtil.defaultBirthday {
            performSegue(withIdentifier: "age", sender: nil)
        } else {
            performSegue(withIdentifier: "add-age", sender: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        loadConfig()
    }

}
