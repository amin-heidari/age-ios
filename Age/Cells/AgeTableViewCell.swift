//
//  AgeTableViewCell.swift
//  Age
//
//  Created by Amin on 2019-05-17.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

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
            timer = Timer.scheduledTimer(timeInterval: 0.01,
                                         target: self,
                                         selector: #selector(refreshAge),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
//    var isRefreshingAge: Bool = false {
//        didSet {
//            if (isRefreshingAge) {
//                timer = Timer.scheduledTimer(timeInterval: 0.01,
//                                             target: self,
//                                             selector: #selector(refreshAge),
//                                             userInfo: nil,
//                                             repeats: true)
//            } else {
//                timer?.invalidate()
//                timer = nil
//            }
//        }
//    }
    
    // MARK: - Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("\(hash) -> Created")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("\(hash) -> awakeFromNib")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("\(hash) -> Prepare for reuse")
    }
    
    // MARK: - Properties
    
    private var ageCalculator: AgeCalculator?
    private var timer: Timer?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var defaultLabel: UILabel!
    
    // MARK: - Methods
    
    @objc private func refreshAge() {
        guard let calculator = ageCalculator else {
            return
        }
        
        ageLabel.text = String(format: "%.8f", calculator.currentAge.value)
    }
    
    // MARK: - Actions
    
    
    
    

}
