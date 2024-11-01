//
//  ServerErrorResponse.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

struct ServerErrorResponse: Codable {
    let code: String
    let message: String
}
