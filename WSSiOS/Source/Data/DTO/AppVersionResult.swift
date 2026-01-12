//
//  AppVersionResult.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 12/21/24.
//

import Foundation

struct AppMinimumVersion: Decodable {
    var minimumVersion: String
    var updateDate: String
}
