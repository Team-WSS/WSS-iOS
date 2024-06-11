//
//  NovelDetailViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import Foundation

import RxSwift
import RxCocoa
import Then

final class NovelDetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let novelDetailRepository: NovelDetailRepository
    private let novelId: Int
    
    private let viewWillAppearEvent = BehaviorRelay(value: false)
    private let novelDetailBasicData = PublishSubject<NovelDetailBasicResult>()
    
    //MARK: - Life Cycle
    
    init(detailRepository: NovelDetailRepository, novelId: Int = 0) {
        self.novelDetailRepository = detailRepository
        self.novelId = novelId
    }
    
    //MARK: - Transform
    
    struct Input {
        let viewWillAppearEvent: Observable<Bool>
        let scrollContentOffset: ControlProperty<CGPoint>
    }
    
    struct Output {
        let detailBasicData: Observable<NovelDetailBasicResult>
        let scrollContentOffset: Driver<CGPoint>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.novelDetailRepository.getNovelBasic(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.novelDetailBasicData.onNext(data)
            }, onError: { owner, error in
                owner.novelDetailBasicData.onError(error)
            })
            .disposed(by: disposeBag)
        
        let scrollContentOffset = input.scrollContentOffset

        return Output(
            detailBasicData: novelDetailBasicData.asObservable(),
            scrollContentOffset: scrollContentOffset.asDriver()
        )
    }
}
