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
    
    private let viewWillAppearEvent = BehaviorRelay<Bool>(value: false)
    private let novelDetailHeaderData = PublishSubject<NovelDetailHeaderResult>()
    private let novelDetailInfoData = PublishSubject<NovelDetailInfoResult>()
    private let showLargeNovelCoverImage = BehaviorRelay<Bool>(value: false)
    private let selectedTab = BehaviorRelay<Tab>(value: Tab.info)
    
    private let isInfoDescriptionExpended = BehaviorRelay<Bool>(value: false)
    private let platformList = BehaviorRelay<[Platform]>(value: [])
    
    //MARK: - Life Cycle
    
    init(detailRepository: NovelDetailRepository, novelId: Int = 0) {
        self.novelDetailRepository = detailRepository
        self.novelId = novelId
    }
    
    //MARK: - Transform
    
    struct Input {
        let viewWillAppearEvent: Observable<Bool>
        let scrollContentOffset: ControlProperty<CGPoint>
        let backButtonDidTap: ControlEvent<Void>
        let novelCoverImageButtonDidTap: ControlEvent<Void>
        let largeNovelCoverImageDismissButtonDidTap: ControlEvent<Void>
        let largeNovelCoverImageBackgroundDidTap: ControlEvent<Void>
        let infoTabBarButtonDidTap: ControlEvent<Void>
        let feedTabBarButtonDidTap: ControlEvent<Void>
        let stickyInfoTabBarButtonDidTap: ControlEvent<Void>
        let stickyFeedTabBarButtonDidTap: ControlEvent<Void>
        let descriptionAccordionButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let detailHeaderData: Observable<NovelDetailHeaderResult>
        let detailInfoData: Observable<NovelDetailInfoResult>
        let scrollContentOffset: Driver<CGPoint>
        let backButtonEnabled: Observable<Void>
        let showLargeNovelCoverImage: Driver<Bool>
        let selectedTab: Driver<Tab>
        let isInfoDescriptionExpended: Driver<Bool>
        let platformList: Driver<[Platform]>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.novelDetailRepository.getNovelDetailHeaderData(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.novelDetailHeaderData.onNext(data)
            }, onError: { owner, error in
                owner.novelDetailHeaderData.onError(error)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.novelDetailRepository.getNovelDetailInfoData(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.novelDetailInfoData.onNext(data)
                owner.platformList.accept(data.platforms)
            }, onError: { owner, error in
                owner.novelDetailInfoData.onError(error)
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
        
        input.largeNovelCoverImageBackgroundDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.showLargeNovelCoverImage.accept(false)
            })
            .disposed(by: disposeBag)
        
        let scrollContentOffset = input.scrollContentOffset
        
        let backButtonDidTap = input.backButtonDidTap.asObservable()
        
        input.infoTabBarButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.feedTabBarButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.feed)
            })
            .disposed(by: disposeBag)
        
        input.stickyInfoTabBarButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.stickyFeedTabBarButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.feed)
            })
            .disposed(by: disposeBag)
        
        input.descriptionAccordionButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.isInfoDescriptionExpended.accept(!owner.isInfoDescriptionExpended.value)
            })
            .disposed(by: disposeBag)
        
        return Output(
            detailHeaderData: novelDetailHeaderData.asObservable(),
            detailInfoData: novelDetailInfoData.asObserver(),
            scrollContentOffset: scrollContentOffset.asDriver(),
            backButtonEnabled: backButtonDidTap,
            showLargeNovelCoverImage: showLargeNovelCoverImage.asDriver(),
            selectedTab: selectedTab.asDriver(),
            isInfoDescriptionExpended: isInfoDescriptionExpended.asDriver(),
            platformList: platformList.asDriver()
        )
    }
}
