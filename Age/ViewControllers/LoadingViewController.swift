//
//  LoadingViewController.swift
//  Age
//
//  Created by Amin on 2019-05-20.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadConfig()
    }
    
    deinit {
        configTask?.cancel()
    }
    
    // MARK: - Properties
    
    private var configTask: URLSessionTask?
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorStackView: UIStackView!
    
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
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
                
                switch (error) {
                case AppError.connection:
                    // Not connected to the internet.
                    self.errorTitleLabel.text = "No Internet!"
                    self.errorDescriptionLabel.text = "It looks like you're not connected to the internet. Please connect and try again!"
                    self.retryButton.isHidden = false
                case AppError.certificateExpired:
                    // Please udpate the app.
                    self.errorTitleLabel.text = "Please upgrade!"
                    self.errorDescriptionLabel.text = "Please upgrade the application from the app store!"
                    self.retryButton.isHidden = true
                default:
                    // Generic message.
                    self.errorTitleLabel.text = "Error!"
                    self.errorDescriptionLabel.text = "An error occured, please try again!"
                    self.retryButton.isHidden = false
                }
            case .success(let remoteConfig):
                self.errorStackView.isHidden = true
                
                switch remoteConfig.version.compare(appVersion: Bundle.main.versionNumber) {
                case .forcedUpgrade:
                    // The app's version is below the minimum required version.
                    self.performSegue(withIdentifier: "upgrade", sender: nil)
                case .optionalUpgrade:
                    // The app's version is below the latest version.
                    if let skippedVersion = UserDefaultsUtil.skippedLatestVersion, skippedVersion.compare(remoteConfig.version.latest, options: .numeric) != .orderedAscending {
                        // User has already skipped to upgrade to that version before.
                        self.proceedToTheApp()
                    } else {
                        // User has never skipped an upgrade to this version.
                        self.performSegue(withIdentifier: "upgrade", sender: nil)
                    }
                case .latestVersion:
                    self.proceedToTheApp()
                }
            }
        }
    }
    
    private func proceedToTheApp() {
        if let _ = UserDefaultsUtil.defaultBirthday {
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
