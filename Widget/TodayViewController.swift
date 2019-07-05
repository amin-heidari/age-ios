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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SuiteDefaultsUtil.suiteName = Constants.UserDefaults.suiteName
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
        
        
    }
    
}
