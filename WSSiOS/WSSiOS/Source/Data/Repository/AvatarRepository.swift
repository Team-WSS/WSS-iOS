//
//  AvatarRepository.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

import RxSwift

protocol AvatarRepository {
    func getAvatarData(avatarId: Int) -> Observable<AvatarResult>
    func patchAvatar(avatarId: Int) -> Observable<Bool>
}

struct DefaultAvatarRepository: AvatarRepository {
    private var avatarService: AvatarService
    
    init(avatarService: AvatarService) {
        self.avatarService = avatarService
    }
    
    func getAvatarData(avatarId: Int) -> RxSwift.Observable<AvatarResult> {
        return avatarService.getAvatarData(avatarId: avatarId)
            .asObservable()
    }
    
    func patchAvatar(avatarId: Int) -> RxSwift.Observable<Bool> {
        return avatarService.patchAvatar(avatarId: avatarId)
            .asObservable()
            .map { true }
            .catchAndReturn(false)
    }
}

