//
//  AppDelegate.swift
//  Age
//
//  Created by Amin on 2019-04-12.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import AgeData
import StoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SuiteDefaultsUtil.suiteName = Constants.UserDefaults.suiteName
        
        // If we're not sure about the state of the in app purchase.
        // Then setup the store utilities.
        // Note that for a regular app we'll always do it. But here we have a single non-consumable IAP so making it simpler.
        if (UserDefaultsUtil.multipleAgesIAPTransactionId == nil) {
            // Add the StoreObserver and restore all payments.
            SKPaymentQueue.default().add(StoreObserver.shared)
            StoreObserver.shared.restore()
        }
            
        FirebaseApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        DatabaseManager.shared.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        DatabaseManager.shared.saveContext()
        
        SKPaymentQueue.default().remove(StoreObserver.shared)
    }

}

// Template to be used on all types:

// MARK: - Constants/Types

// MARK: - Static

// MARK: - API

// MARK: - Life Cycle

// MARK: - Properties

// MARK: - Outlets

// MARK: - Methods

// MARK: - Actions

// MARK: - Delegate

// MARK: - Delegate

