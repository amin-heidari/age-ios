//
//  CallbackUtil.swift
//  Age
//
//  Created by Amin on 2019-06-13.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

enum Either<T> {
    case success(_ data: T)
    case failure(_ error: Error)
}

struct Unit { }

typealias Completion<T> = (_ result: Either<T>) -> Void

typealias Finish<T> = (_ result: T) -> Void
