//
//  Birthday.swift
//  Age
//
//  Created by Amin on 2019-04-22.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class Birthday: Codable {
    let birthDate: BirthDate
    let name: String
    
    init(birthDate: BirthDate, name: String) {
        self.birthDate = birthDate
        self.name = name
    }
    
    private enum CodingKeys: String, CodingKey {
        case birthDate
        case name
    }
}
