//
//  MemoReadViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/24/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MemoReadViewModel: ViewModelType {
    
    //MARK: - Properties
        
    private let memoRepository: MemoRepository
       
    //MARK: - Life Cycle
    
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Int>
        let viewDidTapEvent: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let memoDetail = PublishRelay<MemoDetail>()
        let endEditing = BehaviorRelay<Bool>(value: true)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
//        input.viewWillAppearEvent
//            .flatMapLatest { userNovelId in
//                self.userNovelRepository.getUserNovel(userNovelId: userNovelId)
//                    .observe(on: MainScheduler.instance)
//            }
//            .subscribe(with: self, onNext: { owner, data in
//                output.userNovelDetail.accept(data)
//                output.memoList.accept(data.memos)
//                output.platformList.accept(data.platforms)
//            }, onError: { owner, error in
//                print(error)
//            })
//            .disposed(by: disposeBag)
//        
//        input.viewDidTapEvent
//            .subscribe(with: self, onNext: { owner, _ in
//                output.memoSettingButtonViewIsHidden.accept(true)
//            })
//            .disposed(by: disposeBag)
        
        return output
    }
    
//    private func getUserNovel(userNovelId: Int) -> Observable<UserNovelDetail> {
//        userNovelRepository.getUserNovel(userNovelId: userNovelId)
//            .observe(on: MainScheduler.instance)
//    }
}
