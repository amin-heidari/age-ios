//
//  Either.swift
//  Age
//
//  Created by Amin on 2019-05-29.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

enum Either<T> {
    case success(_ data: T)
    case failure(_ error: Error)
}
