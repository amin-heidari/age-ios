//
//  BirthDate.swift
//  Age
//
//  Created by Amin on 2019-06-13.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class BirthDate: Codable {
    let year: Int
    let month: Int
    let day: Int
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}
