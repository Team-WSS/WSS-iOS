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
    private let showEmptyView = BehaviorRelay<Bool>(value: false)
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
        let showEmptyView: Driver<Bool>
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
                if data.blocks.isEmpty {
                    owner.showEmptyView.accept(true)
                }
                owner.bindCellReleay.accept(data.blocks)
            })
            .disposed(by: disposeBag)
        
        input.unblockButtonDidTap
            .subscribe(with: self, onNext: { owner, indexPath in
                let blockID = owner.bindCellReleay.value[indexPath.row].blockId
                print(indexPath)
                owner.deleteBlockUser(blockID: blockID)
            })
            .disposed(by: disposeBag)
        
        return Output(showEmptyView: showEmptyView.asDriver(),
                      popViewController: popViewController,
                      bindCell: bindCellReleay,
                      reloadTableView: reloadTableView)
    }
    
    //MARK: - API
    
    private func getBlockUserList() -> Observable<BlockUserResult> {
//        return self.userRepository.getBlocksList()
        let blockUserReult = [blockList(blockId: 0, userId: 0, nickname: "jiwon", avatarImage: "https://i.pinimg.com/564x/a2/48/0a/a2480aceb3d0881e5aaa921209cf61c8.jpg"),
                              blockList(blockId: 1, userId: 1, nickname: "ena", avatarImage: "https://i.pinimg.com/564x/a2/48/0a/a2480aceb3d0881e5aaa921209cf61c8.jpg"),
                              blockList(blockId: 2, userId: 2, nickname: "신지원", avatarImage: "https://i.pinimg.com/564x/a2/48/0a/a2480aceb3d0881e5aaa921209cf61c8.jpg"),
                              blockList(blockId: 3, userId: 3, nickname: "메롱메롱메롱메롱메롱", avatarImage: "https://i.pinimg.com/564x/a2/48/0a/a2480aceb3d0881e5aaa921209cf61c8.jpg"),
                              blockList(blockId: 4, userId: 4, nickname: "짱부라부하이나", avatarImage: "https://i.pinimg.com/564x/a2/48/0a/a2480aceb3d0881e5aaa921209cf61c8.jpg")]
        let relay = BehaviorRelay<BlockUserResult>(value: BlockUserResult(blocks: blockUserReult))
        return relay.asObservable()
    }
    
    private func deleteBlockUser(blockID: Int) -> Observable<Void> {
        print(blockID)
        return self.userRepository.deleteBlockUser(blockID: blockID)
    }
}

