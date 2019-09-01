//
//  BaseViewController.swift
//  Age
//
//  Created by Amin on 2019-06-03.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidReceiveMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationSignificantTimeChange), name: UIApplication.significantTimeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillChangeStatusBarOrientation), name: UIApplication.willChangeStatusBarOrientationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidChangeStatusBarOrientation), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillChangeStatusBarFrame), name: UIApplication.willChangeStatusBarFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidChangeStatusBarFrame), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBackgroundRefreshStatusDidChange), name: UIApplication.backgroundRefreshStatusDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationProtectedDataWillBecomeUnavailable), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationProtectedDataDidBecomeAvailable), name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationUserDidTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
        (UIApplication.shared.keyWindow?.rootViewController as? RootViewController)?.appStatusBarStyle = appStatusBarStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Properties
    
    var isNavigationBarHidden: Bool { return false }
    
    var appStatusBarStyle: UIStatusBarStyle { return .default }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    @objc func applicationDidEnterBackground() { }
    @objc func applicationWillEnterForeground() { }
    @objc func applicationDidFinishLaunching() { }
    @objc func applicationDidBecomeActive() { }
    @objc func applicationWillResignActive() { }
    @objc func applicationDidReceiveMemoryWarning() { }
    @objc func applicationWillTerminate() { }
    @objc func applicationSignificantTimeChange() { }
    @objc func applicationWillChangeStatusBarOrientation() { }
    @objc func applicationDidChangeStatusBarOrientation() { }
    @objc func applicationWillChangeStatusBarFrame() { }
    @objc func applicationDidChangeStatusBarFrame() { }
    @objc func applicationBackgroundRefreshStatusDidChange() { }
    @objc func applicationProtectedDataWillBecomeUnavailable() { }
    @objc func applicationProtectedDataDidBecomeAvailable() { }
    @objc func applicationUserDidTakeScreenshot() { }
    
    // MARK: - Actions

}
