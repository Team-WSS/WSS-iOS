//
//  AvatarRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol AvatarRepository {
    func getAvatarList() -> Observable<AvatarResponse>
}

struct DefaultAvatarRepository: AvatarRepository {
    private var avatarService: AvatarService
    
    init(avatarService: AvatarService) {
        self.avatarService = avatarService
    }
    
    func getAvatarList() -> Observable<AvatarResponse> {
        return avatarService.getAvatarList()
            .asObservable()
    }
}

