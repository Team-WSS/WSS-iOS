//
//  MyPageBlockUserViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageBlockUserViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    private var dummyData = [
        blockList(blockId: 0, userId: 0, nickname: "", avatarImage: ""),
        blockList(blockId: 0, userId: 0, nickname: "", avatarImage: "")
    ]
    
    //MARK: - Life Cycle
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let popViewController = PublishRelay<Bool>()
        let bindCell = BehaviorRelay<[blockList]>(value: 
                                                    [blockList(blockId: 0, userId: 0, nickname: "", avatarImage: "")])
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        //서버연결
        
        let blockUserResult = BlockUserResult(blocks: dummyData)
        let bindCell = Observable.just(blockUserResult.blocks)
        
        return output
    }
    
    //MARK: - API
    
    private func getBlockUserData(avatar: Int) -> Observable<[BlockUserResult]> {
        return self.avatarRepository.getAvatarData(avatarId: avatar)
    }
    
}

