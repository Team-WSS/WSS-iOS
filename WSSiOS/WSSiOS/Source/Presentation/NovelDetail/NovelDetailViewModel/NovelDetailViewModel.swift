//
//  NovelDetailViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelDetailViewModel: ViewModelType {
    
    private let userNovelRepository: UserNovelRepository
    
    init(userNovelRepository: UserNovelRepository) {
        self.userNovelRepository = userNovelRepository
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Int>
        let memoTableViewContentSize: Observable<CGSize?>
        let platformCollectionViewContentSize: Observable<CGSize?>
        let novelSettingButtonDidTapEvent: Observable<Void>
        let viewDidTapEvent: Observable<UITapGestureRecognizer>
        let memoButtonDidTapEvent: Observable<Void>
        let infoButtonDidTapEvent: Observable<Void>
        let stickyMemoButtonDidTapEvent: Observable<Void>
        let stickyInfoButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let userNovelDetail = PublishRelay<UserNovelDetail>()
        let memoList = BehaviorRelay<[UserNovelMemo]>(value: [])
        let platformList = BehaviorRelay<[UserNovelPlatform]>(value: [])
        let memoTableViewHeight = BehaviorRelay<CGFloat>(value: 0)
        let platformCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
        let memoSettingButtonViewIsHidden = BehaviorRelay<Bool>(value: true)
        let selectedMenu = BehaviorRelay<SelectedMenu>(value: .memo)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .flatMapLatest { userNovelId in
                self.userNovelRepository.getUserNovel(userNovelId: userNovelId)
                    .observe(on: MainScheduler.instance)
            }
            .subscribe(with: self, onNext: { owner, data in
                output.userNovelDetail.accept(data)
                output.memoList.accept(data.memos)
                output.platformList.accept(data.platforms)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.memoTableViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: output.memoTableViewHeight)
            .disposed(by: disposeBag)
        
        input.platformCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: output.platformCollectionViewHeight)
            .disposed(by: disposeBag)
        
        input.novelSettingButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                if output.memoSettingButtonViewIsHidden.value == false {
                    output.memoSettingButtonViewIsHidden.accept(true)
                } else {
                    output.memoSettingButtonViewIsHidden.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.memoSettingButtonViewIsHidden.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.memoButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.selectedMenu.accept(.memo)
            })
            .disposed(by: disposeBag)
        
        input.infoButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.selectedMenu.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.stickyMemoButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.selectedMenu.accept(.memo)
            })
            .disposed(by: disposeBag)
        
        input.stickyInfoButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.selectedMenu.accept(.info)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func getUserNovel(userNovelId: Int) -> Observable<UserNovelDetail> {
        userNovelRepository.getUserNovel(userNovelId: userNovelId)
            .observe(on: MainScheduler.instance)
    }
}
