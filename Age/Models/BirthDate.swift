//
//  BirthDate.swift
//  Age
//
//  Created by Amin on 2019-06-13.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class BirthDate: Codable {
    let year: Int16
    let month: Int16
    let day: Int16
    
    init(year: Int16, month: Int16, day: Int16) {
        self.year = year
        self.month = month
        self.day = day
    }
}
