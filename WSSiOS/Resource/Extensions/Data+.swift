//
//  Data+.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
