//
//  AgeTableViewCell.swift
//  Age
//
//  Created by Amin on 2019-05-17.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import AgeData

private extension RemoteConfig.AgesCard {
    var startUIColor: UIColor { return UIColor(hex: startColor) ?? UIColor.primary }
    var endUIColor: UIColor { return UIColor(hex: endColor) ?? UIColor.primary }
}

class AgeTableViewCell: UITableViewCell {
    
    // MARK: - Constants/Types
    
    // Could be an enum with associated values, could be a struct, or anything else, they are all the same.
    // Decided to go with the simplest here.
    typealias Item = (birthday: Birthday, isDefault: Bool, agesCard: RemoteConfig.AgesCard)
    
    // MARK: - Static
    
    // MARK: - API
    
    var item: Item? {
        didSet {
            guard let item = item else {
                return
            }
            
            defaultLabel.isHidden = !item.isDefault
            nameLabel.text = item.birthday.name
            birthDateLabel.text = String(format: "Born on %@", item.birthday.birthDate.date.birthDateFormatted)
            ageCalculator = AgeCalculator(birthDate: item.birthday.birthDate)
            gradientView.startColor = item.agesCard.startUIColor
            gradientView.endColor = item.agesCard.endUIColor
        }
    }
    
    func refreshAge() {
        guard let calculator = ageCalculator else { return }
        
        let age = calculator.currentAge
        ageFullLabel.text = String(format: "%d", age.full)
        ageRationalLabel.text = String(format: ".%08d", Int(round(age.rational * 100000000)))
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
    
    @IBOutlet private weak var gradientView: GradientView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageFullLabel: UILabel!
    @IBOutlet private weak var ageRationalLabel: UILabel!
    @IBOutlet private weak var defaultLabel: UILabel!
    @IBOutlet private weak var birthDateLabel: UILabel!
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    
    
    

}
