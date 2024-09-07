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
    
    /// 정보 뷰
    private let cancelButtonEnabled = PublishRelay<Bool>()
    private let genreList = BehaviorRelay<[String]>(value: NovelGenre.allCases.map { $0.toKorean })
    private let selectedTab = BehaviorRelay<DetailSearchTab>(value: DetailSearchTab.info)
    
    /// 키워드 뷰
    private let worldKeywordList = BehaviorRelay<[String]>(value: ["서양풍/중세시대", "현대", "이세계", "SF", "동양풍/사극", "학원/아카데미", "실존역사"])
    private let keywordCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    struct Input {
        let cancelButtonDidTap: ControlEvent<Void>
        let genreCollectionViewContentSize: Observable<CGSize?>
        let infoTabDidTap: Observable<UITapGestureRecognizer>
        let keywordTabDidTap: Observable<UITapGestureRecognizer>
        
        let keywordCollectionViewContentSize: Observable<CGSize?>
    }
    
    struct Output {
        let cancelButtonEnabled: Observable<Void>
        let genreList: Driver<[String]>
        let genreCollectionViewHeight: Driver<CGFloat>
        let selectedTab: Driver<DetailSearchTab>
        
        let worldKeywordList: Driver<[String]>
        let keywordCollectionViewHeight: Driver<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        let cancelButtonEnabled = input.cancelButtonDidTap.asObservable()
        
        let genreCollectionViewContentSize = input.genreCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
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
        
        let keywordCollectionViewContentSize = input.keywordCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(cancelButtonEnabled: cancelButtonEnabled,
                      genreList: genreList.asDriver(),
                      genreCollectionViewHeight: genreCollectionViewContentSize,
                      selectedTab: selectedTab.asDriver(),
                      worldKeywordList: worldKeywordList.asDriver(),
                      keywordCollectionViewHeight: keywordCollectionViewContentSize)
    }
    
    //MARK: - Custom Method
    
    func genreNameForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < genreList.value.count else {
            return nil
        }
        
        return genreList.value[indexPath.item]
    }
    
    func worldNameForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < worldKeywordList.value.count else {
            return nil
        }
        
        return worldKeywordList.value[indexPath.item]
    }
}
