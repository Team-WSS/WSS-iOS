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
    
    private let detailRepository: DetailRepository
    private let novelId: Int
    
    private let viewWillAppearEvent = BehaviorRelay(value: false)
    private let detailBasicData = PublishSubject<DetailBasicResult>()
    
    //MARK: - Life Cycle
    
    init(detailRepository: DetailRepository, novelId: Int = 0) {
        self.detailRepository = detailRepository
        self.novelId = novelId
    }
    
    //MARK: - Transform
    
    struct Input {
        let viewWillAppearEvent: Observable<Bool>
        let scrollContentOffset: ControlProperty<CGPoint>
    }
    
    struct Output {
        let detailBasicData: Observable<DetailBasicResult>
        let scrollContentOffset: Driver<CGPoint>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.detailRepository.getNovelBasic(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.detailBasicData.onNext(data)
            }, onError: { owner, error in
                owner.detailBasicData.onError(error)
            })
            .disposed(by: disposeBag)
        
        let scrollContentOffset = input.scrollContentOffset

        return Output(
            detailBasicData: detailBasicData.asObservable(), scrollContentOffset: scrollContentOffset.asDriver())
    }
}
