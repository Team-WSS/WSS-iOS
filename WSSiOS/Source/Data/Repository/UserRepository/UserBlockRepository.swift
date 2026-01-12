//
//  UserBlockRepository.swift
//  WSSiOS
//
//  Created by 신지원 on 3/6/25.
//

import Foundation

import RxSwift

protocol UserBlockRepository {
    func getBlocksList() -> Observable<BlockUserListEntity>
    func deleteBlockUser(blockID: Int) -> Observable<Void>
    func postBlockUser(userId: Int) -> Observable<Void>
}

struct DefaultUserBlockRepository: UserBlockRepository {
    private var blocksService: BlocksService
    
    init(blocksService: BlocksService) {
        self.blocksService = blocksService
    }
    
    //MARK: - BlockService
    
    func getBlocksList() -> Observable<BlockUserListEntity> {
        return blocksService.getBlocksList()
            .map { $0.toEntity() }
            .asObservable()
    }
    
    func deleteBlockUser(blockID: Int) -> Observable<Void> {
        return blocksService.deleteBlockUser(blockID: blockID)
            .asObservable()
    }
    
    func postBlockUser(userId: Int) -> Observable<Void> {
        return blocksService.postBlockUser(blockID: userId)
            .asObservable()
    }
}
