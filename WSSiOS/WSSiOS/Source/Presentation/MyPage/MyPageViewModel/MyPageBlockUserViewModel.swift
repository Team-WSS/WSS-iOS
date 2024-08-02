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
    private var bindCellReleay = BehaviorRelay<[blockList]>(value: [])
    private let popViewController = PublishRelay<Bool>()
    private let reloadTableView = PublishRelay<Bool>()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    //MARK: - Life Cycle
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let unblockButtonDidTap: Observable<IndexPath>
    }
    
    struct Output {
        let popViewController: PublishRelay<Bool>
        let bindCell: BehaviorRelay<[blockList]>
        let reloadTableView: PublishRelay<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        getBlockUserList()
            .subscribe(with: self, onNext: { owner, data in
                owner.bindCellReleay.accept(data.blocks)
            })
            .disposed(by: disposeBag)
        
        input.unblockButtonDidTap
            .subscribe(with: self, onNext: { owner, indexPath in
                let blockID = owner.bindCellReleay.value[indexPath.row].blockId
                owner.deleteBlockUser(blockID: blockID)
            })
            .disposed(by: disposeBag)
        
        return Output(popViewController: popViewController,
                      bindCell: bindCellReleay,
                      reloadTableView: reloadTableView)
    }
    
    //MARK: - API
    
    private func getBlockUserList() -> Observable<BlockUserResult> {
        return self.userRepository.getBlocksList()
    }
    
    private func deleteBlockUser(blockID: Int) -> Observable<Void> {
        print(blockID)
        return self.userRepository.deleteBlockUser(blockID: blockID)
    }
}

