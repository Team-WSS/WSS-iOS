//
//  UserRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 1/5/24.
//

import Foundation

import RxSwift

protocol UserRepository {
    var userInfoRepository: UserInfoRepository { get }
    var userBlockRepository: UserBlockRepository { get }
}

struct DefaultUserRepository: UserRepository {
    var userInfoRepository: any UserInfoRepository
    var userBlockRepository: any UserBlockRepository
}
