//
//  RegisterNormalViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output
}

class RegisterNormalViewModel: ViewModelType {
    
    
    let novelRepository: NovelRepository
    let userNovelRepository: UserNovelRepository
    let novelId: Int
    var userNovelId: Int
    
    private let disposeBag = DisposeBag()
    let novelInfo = PublishSubject<NovelResult>()
    let isNew = BehaviorRelay<Bool>(value: true)
    
    init(novelRepository: NovelRepository, userNovelRepository: UserNovelRepository, novelId: Int = 0, userNovelId: Int = 0) {
        self.novelRepository = novelRepository
        self.userNovelRepository = userNovelRepository
        self.novelId = novelId
        self.userNovelId = userNovelId
    }
    
    struct Input {
        let readDateToggleButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let novelInfo: Observable<NovelResult>
        let isNew: Driver<Bool>
        let isDateExist: Driver<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        novelInfo
            .subscribe(with: self, onNext: { owner, data in
                owner.isNew.accept(data.newNovelResult != nil)
            })
            .disposed(by: disposeBag)
        
        let isDateExist = novelInfo.map { data in
            let start = data.editNovelResult?.userNovelReadDate.userNovelReadEndDate
            let end = data.editNovelResult?.userNovelReadDate.userNovelReadEndDate
            
            if self.isNew.value {
                return true
            } else {
                return (start != nil) || (end != nil)
            }
        }.asDriver(onErrorJustReturn: true)
        
        
        return Output(
            novelInfo: novelInfo.asObservable(),
            isNew: isNew.asDriver(),
            isDateExist: isDateExist
        )
    }
    
    func getNovelInfo() {
        novelRepository.getNovelInfo(novelId: novelId)
            .subscribe(with: self, onNext: { owner, data in
                owner.novelInfo.onNext(data)
            }, onError: { owner, error in
                owner.novelInfo.onError(error)
            })
            .disposed(by: disposeBag)
    }
}
