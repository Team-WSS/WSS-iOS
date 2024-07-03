//
//  TrashNovelDetailViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/23/24.
//

import UIKit

import RxSwift
import RxCocoa

enum TrashSelectedMenu {
    case memo
    case info
}

final class TrashNovelDetailViewModel: ViewModelType {
    
    //MARK: - Properties
        
    private let userNovelRepository: UserNovelRepository
    
    private let selectedMenu: TrashSelectedMenu
    
    //MARK: - Life Cycle
    
    init(userNovelRepository: UserNovelRepository, selectedMenu: TrashSelectedMenu = .memo) {
        self.userNovelRepository = userNovelRepository
        self.selectedMenu = selectedMenu
    }
    
    struct Input {
        let viewWillAppear: Observable<Int>
        let scrollViewContentOffset: Driver<CGPoint>
        let memoTableViewContentSize: Observable<CGSize?>
        let platformCollectionViewContentSize: Observable<CGSize?>
        let novelSettingButtonDidTap: Observable<Void>
        let viewDidTap: Observable<UITapGestureRecognizer>
        let memoButtonDidTap: Observable<Void>
        let infoButtonDidTap: Observable<Void>
        let stickyMemoButtonDidTap: Observable<Void>
        let stickyInfoButtonDidTap: Observable<Void>
        let novelDeleteButtonDidTap: Observable<Void>
        let novelEditButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let userNovelDetail = PublishRelay<UserNovelDetail>()
        let memoList = BehaviorRelay<[UserNovelMemo]>(value: [])
        let platformList = BehaviorRelay<[UserNovelPlatform]>(value: [])
        let contentOffsetY = BehaviorRelay<CGFloat>(value: 0)
        let memoTableViewHeight = BehaviorRelay<CGFloat>(value: 0)
        let platformCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
        let memoSettingButtonViewIsHidden = BehaviorRelay<Bool>(value: true)
        let selectedMenu = BehaviorRelay<TrashSelectedMenu>(value: .memo)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        output.selectedMenu.accept(self.selectedMenu)
        
        input.viewWillAppear
            .flatMapLatest { userNovelId in
                self.getUserNovel(userNovelId: userNovelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                output.userNovelDetail.accept(data)
                output.memoList.accept(data.memos)
                output.platformList.accept(data.platforms)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.scrollViewContentOffset
            .map { $0.y }
            .drive(output.contentOffsetY)
            .disposed(by: disposeBag)
        
        input.memoTableViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: output.memoTableViewHeight)
            .disposed(by: disposeBag)
        
        input.platformCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: output.platformCollectionViewHeight)
            .disposed(by: disposeBag)
        
        input.novelSettingButtonDidTap
            .subscribe(onNext: {
                if output.memoSettingButtonViewIsHidden.value == false {
                    output.memoSettingButtonViewIsHidden.accept(true)
                } else {
                    output.memoSettingButtonViewIsHidden.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidTap
            .subscribe(onNext: { _ in
                output.memoSettingButtonViewIsHidden.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.memoButtonDidTap
            .subscribe(onNext: {
                output.selectedMenu.accept(.memo)
            })
            .disposed(by: disposeBag)
        
        input.infoButtonDidTap
            .subscribe(onNext: {
                output.selectedMenu.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.stickyMemoButtonDidTap
            .subscribe(onNext: {
                output.selectedMenu.accept(.memo)
            })
            .disposed(by: disposeBag)
        
        input.stickyInfoButtonDidTap
            .subscribe(onNext: {
                output.selectedMenu.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.novelDeleteButtonDidTap
            .subscribe(onNext: {
                output.memoSettingButtonViewIsHidden.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.novelEditButtonDidTap
            .subscribe(onNext: {
                output.selectedMenu.accept(.info)
                output.memoSettingButtonViewIsHidden.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func getUserNovel(userNovelId: Int) -> Observable<UserNovelDetail> {
        userNovelRepository.getUserNovel(userNovelId: userNovelId)
            .observe(on: MainScheduler.instance)
    }
}
