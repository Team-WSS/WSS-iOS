//
//  UserInfoResult.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import Foundation

struct UserMeResult: Decodable {
    let userId: Int
    let nickname: String
    let gender: String
}

struct UserNickNameRequest: Encodable {
    let userNickname: String
}

struct UserInfoResponse: Decodable {
    let email: String?
    let gender: String
    let birth: Int
}

struct ChangeUserInfoRequest: Encodable {
    let gender: String
    let birth: Int
}
