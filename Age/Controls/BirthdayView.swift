//
//  BirthdayView.swift
//  Age
//
//  Created by Amin on 2019-06-15.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class BirthdayView: UIView {

    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BirthdayView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func willMove(toSuperview newSuperview: UIView?) { }
    
    deinit { }
    
    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateOfBirthLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    
    // MARK: - Methods
    
    // MARK: - Actions
    
}
