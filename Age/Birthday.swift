//
//  Birthday.swift
//  Age
//
//  Created by Amin on 2019-04-22.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class Birthday: Codable {
    let birthDate: Date
    let name: String
    
    init(birthDate: Date, name: String) {
        self.birthDate = birthDate
        self.name = name
    }
}
