//
//  DetailSearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import RxRelay

final class DetailSearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let keywordRepository: KeywordRepository
    
    /// 정보 뷰
    private let cancelButtonEnabled = PublishRelay<Bool>()
    private let genreList = BehaviorRelay<[String]>(value: NovelGenre.allCases.map { $0.toKorean })
    private let selectedTab = BehaviorRelay<DetailSearchTab>(value: DetailSearchTab.info)
    
    /// 키워드 뷰
    private let viewWillAppearEvent = BehaviorRelay<Bool>(value: false)
    private let keywordList = PublishSubject<[DetailSearchCategory]>()
    
    struct Input {
        let viewWillAppearEvent: Observable<Bool>
        let cancelButtonDidTap: ControlEvent<Void>
        let genreCollectionViewContentSize: Observable<CGSize?>
        let infoTabDidTap: Observable<UITapGestureRecognizer>
        let keywordTabDidTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let cancelButtonEnabled: Observable<Void>
        let genreList: Driver<[String]>
        let genreCollectionViewHeight: Driver<CGFloat>
        let selectedTab: Driver<DetailSearchTab>
        
        let keywordList: Observable<[DetailSearchCategory]>
    }
    
    //MARK: - init
    
    init(keywordRepository: KeywordRepository) {
        self.keywordRepository = keywordRepository
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        let cancelButtonEnabled = input.cancelButtonDidTap.asObservable()
        
        let genreCollectionViewContentSize = input.genreCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.keywordRepository.getKeywords()
            }
            .subscribe(with: self, onNext: { owner, data in
                self.keywordList.onNext(data.categories)
            }, onError: { owner, error in
                self.keywordList.onError(error)
            })
            .disposed(by: disposeBag)
        
        input.infoTabDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.keywordTabDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.keyword)
            })
            .disposed(by: disposeBag)
        
        keywordRepository.getKeywords()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                self.keywordList.onNext(data.categories)
            }, onError: { owner, error in
                self.keywordList.onError(error)
            })
            .disposed(by: disposeBag)
        
        return Output(cancelButtonEnabled: cancelButtonEnabled,
                      genreList: genreList.asDriver(),
                      genreCollectionViewHeight: genreCollectionViewContentSize,
                      selectedTab: selectedTab.asDriver(),
                      keywordList: keywordList.asObservable())
    }
    
    //MARK: - Custom Method
    
    func genreNameForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < genreList.value.count else {
            return nil
        }
        
        return genreList.value[indexPath.item]
    }
}
