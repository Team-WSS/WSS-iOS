//
//  UserCharacterResult.swift
//  WSSiOS
//
//  Created by 최서연 on 1/16/24.
//

import Foundation

struct UserCharacter: Codable {
    let avatarId: Int
    let avatarTag: String
    let avatarComment: String
    let userNickname: String
    
    enum CodingKeys: String, CodingKey {
        case avatarId
        case avatarTag
        case avatarComment = "avatarLine"
        case userNickname
    }
}
