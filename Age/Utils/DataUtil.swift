//
//  DataUtil.swift
//  Age
//
//  Created by Amin on 2019-07-09.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
    
    func appending(_ other: Data) -> Data {
        var appended = Data(self)
        appended.append(other)
        return appended
    }
    
    var raw: String {
        return self.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
    var sha512: Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        self.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(self.count), &digest)
        })
        var result = Data()
        result.append(contentsOf: digest)
        return result
    }
    
}
