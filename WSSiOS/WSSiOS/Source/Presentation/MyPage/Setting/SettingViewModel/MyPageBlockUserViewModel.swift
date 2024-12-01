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
    private var bindCellReleay = BehaviorRelay<[BlockUser]>(value: [])
    private let showEmptyView = PublishRelay<Bool>()
    private let popViewController = PublishRelay<Bool>()
    private let reloadTableViewRelay = PublishRelay<Bool>()
    private let toastMessage = PublishRelay<String>()
    
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
        let bindCell: BehaviorRelay<[BlockUser]>
        let reloadTableView: PublishRelay<Bool>
        let toastMessage: PublishRelay<String>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.backButtonDidTap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
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
            .throttle(.seconds(Int(0.5)), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] indexPath -> Observable<String> in
                
                var blocks = self.bindCellReleay.value
                let blockID = blocks[indexPath.row].blockId
                var nickName = blocks[indexPath.row].nickname
                if nickName.count > 8 {
                    nickName = nickName.prefix(8) + "..."
                }
                
                return self.deleteBlockUser(blockID: blockID)
                    .map { _ -> String in
                        blocks.remove(at: indexPath.row)
                        self.bindCellReleay.accept(blocks)
                        if blocks.isEmpty {
                            self.showEmptyView.accept(true)
                        }
                        self.reloadTableViewRelay.accept(true)
                        return nickName
                    }
            }
            .subscribe(onNext: { [weak self] nickName in
                self?.toastMessage.accept(nickName)
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        return Output(showEmptyView: showEmptyView.asDriver(onErrorJustReturn: true),
                      popViewController: popViewController,
                      bindCell: bindCellReleay,
                      reloadTableView: reloadTableViewRelay,
                      toastMessage: toastMessage)
    }
    
    //MARK: - API
    
    private func getBlockUserList() -> Observable<BlockUserResult> {
        return self.userRepository.getBlocksList()
    }
    
    private func deleteBlockUser(blockID: Int) -> Observable<Void> {
        return self.userRepository.deleteBlockUser(blockID: blockID)
    }
}
