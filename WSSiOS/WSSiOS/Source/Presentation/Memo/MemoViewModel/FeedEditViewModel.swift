//
//  FeedEditViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedEditViewModel: ViewModelType {
    
    //MARK: - Properties
        
    private let memoRepository: MemoRepository
    
    let dummyCategoryList = ["로맨스",
                             "로판",
                             "BL",
                             "판타지",
                             "현판",
                             "무협",
                             "드라마",
                             "미스터리",
                             "라노벨",
                             "기타"]
       
    //MARK: - Life Cycle
    
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let categoryListData = PublishRelay<[String]>()
        let popViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.categoryListData.accept(owner.dummyCategoryList)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: { _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
