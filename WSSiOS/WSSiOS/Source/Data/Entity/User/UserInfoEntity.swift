//
//  UserInfoEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/6/25.
//

import Foundation

struct UserMeEntity {
    let userId: Int
    let nickname: String
    let gender: String
}

extension UserMeResponse {
    func toEntity() -> UserMeEntity {
        return UserMeEntity(userId: self.userId,
                            nickname: self.nickname,
                            gender: self.gender)
    }
}

struct UserInfoEntity {
    let email: String
    let gender: String
    let birth: Int
}

extension UserInfoResponse {
    func toEntity() -> UserInfoEntity {
        let emailText = self.email ?? ""
        return UserInfoEntity(email: emailText,
                              gender: self.gender,
                              birth: self.birth)
    }
}

struct ChangeUserInfoEntity {
    let gender: String
    let birth: Int
}

extension ChangeUserInfoEntity {
    func toDTO() -> ChangeUserInfoRequest {
        return ChangeUserInfoRequest(gender: self.gender,
                                     birth: self.birth)
    }
}

//TODO: 아래부턴 구현만 해놓음, 적용하기 위해선 전반적으로 수정 필요

enum UserGender {
    case male
    case female
}

//struct UserInfoEntity {
//    let email: String
//    let gender: UserGender
//    let birth: Int
//}
//
//extension UserInfoResponse {
//    func toEntity() -> UserInfoEntity {
//        let emailText = self.email ?? ""
//        let gender: UserGender = self.gender == "M" ? .male : .female
//        return UserInfoEntity(email: emailText,
//                              gender: gender,
//                              birth: self.birth)
//    }
//}
//
//struct ChangeUserInfoEntity {
//    let gender: UserGender
//    let birth: Int
//}
//
//extension ChangeUserInfoEntity {
//    func toDTO() -> ChangeUserInfoRequest {
//        var gender = ""
//        if self.gender == .male {
//            gender = "M"
//        } else if self.gender == .female {
//            gender = "F"
//        }
//        return ChangeUserInfoRequest(gender: gender,
//                                     birth: self.birth)
//    }
//}
