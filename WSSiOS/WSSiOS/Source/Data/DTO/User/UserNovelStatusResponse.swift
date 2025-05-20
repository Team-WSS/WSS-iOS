//
//  UserNovelStatusResult.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import Foundation

struct UserNovelStatusResponse: Decodable {
    var interestNovelCount: Int
    var watchingNovelCount: Int
    var watchedNovelCount: Int
   var quitNovelCount: Int
}
