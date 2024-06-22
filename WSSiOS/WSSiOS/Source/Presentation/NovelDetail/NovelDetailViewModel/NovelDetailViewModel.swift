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
    private let novelDetailBasicData = PublishSubject<NovelDetailHeaderResult>()
    private let showLargeNovelCoverImage = BehaviorRelay<Bool>(value: false)
    
    //MARK: - Life Cycle
    
    init(detailRepository: NovelDetailRepository, novelId: Int = 0) {
        self.novelDetailRepository = detailRepository
        self.novelId = novelId
    }
    
    //MARK: - Transform
    
    struct Input {
        let viewWillAppearEvent: Observable<Bool>
        let scrollContentOffset: ControlProperty<CGPoint>
        let novelCoverImageButtonDidTap: ControlEvent<Void>
        let largeNovelCoverImageDismissButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let detailBasicData: Observable<NovelDetailHeaderResult>
        let scrollContentOffset: Driver<CGPoint>
        let showLargeNovelCoverImage: Driver<Bool>
        let backButtonDidTap: Observable<Void>
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
        
        input.novelCoverImageButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.showLargeNovelCoverImage.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.largeNovelCoverImageDismissButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.showLargeNovelCoverImage.accept(false)
            })
            .disposed(by: disposeBag)
        
        let scrollContentOffset = input.scrollContentOffset
        
        let backButtonDidTap = input.backButtonDidTap.asObservable()
        
        return Output(
            detailBasicData: novelDetailBasicData.asObservable(),
            scrollContentOffset: scrollContentOffset.asDriver(),
            showLargeNovelCoverImage: showLargeNovelCoverImage.asDriver(),
            backButtonDidTap: backButtonDidTap
        )
    }
}
