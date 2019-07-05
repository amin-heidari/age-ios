//
//  AgeTableViewCell.swift
//  Age
//
//  Created by Amin on 2019-05-17.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import AgeData

class AgeTableViewCell: UITableViewCell {
    
    // MARK: - Constants/Types
    
    // Could be an enum with associated values, could be a struct, or anything else, they are all the same.
    // Decided to go with the simplest here.
    typealias Item = (birthday: Birthday, isDefault: Bool)
    
    // MARK: - Static
    
    // MARK: - API
    
    var item: Item? {
        didSet {
            guard let item = item else {
                return
            }
            
            defaultLabel.isHidden = !item.isDefault
                
            nameLabel.text = item.birthday.name
            ageLabel.text = String(format: "%d - %d - %d", item.birthday.birthDate.year, item.birthday.birthDate.month, item.birthday.birthDate.day)
            
            ageCalculator = AgeCalculator(birthDate: item.birthday.birthDate)
        }
    }
    
    func refreshAge() {
        guard let calculator = ageCalculator else { return }
        
        ageLabel.text = String(format: "%.8f", calculator.currentAge.value)
    }
    
    // MARK: - Life Cycle
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ageCalculator = nil
    }
    
    deinit {
        ageCalculator = nil
    }
    
    // MARK: - Properties
    
    private var ageCalculator: AgeCalculator?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var defaultLabel: UILabel!
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    
    
    

}
