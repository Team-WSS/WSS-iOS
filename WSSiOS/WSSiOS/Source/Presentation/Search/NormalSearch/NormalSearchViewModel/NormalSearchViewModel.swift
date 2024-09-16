//
//  NormalSearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NormalSearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let searchRepository: SearchRepository
    private let disposeBag = DisposeBag()
    
    private let resultCount = PublishSubject<Int>()
    private let normalSearchList = PublishSubject<[NormalSearchNovel]>()
    private let backButtonEnabled = PublishRelay<Bool>()
    private let inquiryButtonEnabled = PublishRelay<Bool>()
    private let normalSearchCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    //MARK: - Inputs
    
    struct Input {
        let searchTextUpdated: ControlProperty<String>
        let searchTextReturnKeyPressed: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        let inquiryButtonDidTap: ControlEvent<Void>
        let normalSearchCollectionViewContentSize: Observable<CGSize?>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let resultCount: Observable<Int>
        let normalSearchList: Observable<[NormalSearchNovel]>
        let backButtonEnabled: Observable<Void>
        let inquiryButtonEnabled: Observable<Void>
        let normalSearchCollectionViewHeight: Driver<CGFloat>
    }
    
    //MARK: - init
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    //MARK: - Methods
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {

        input.searchTextReturnKeyPressed
            .withLatestFrom(input.searchTextUpdated)
            .filter { !$0.isEmpty }
            .flatMapLatest { text in
                self.searchRepository.getSearchNovels(query: text)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.normalSearchList.onNext(data.novels)
                owner.resultCount.onNext(data.resultCount)
            })
            .disposed(by: disposeBag)
        
        let backButtonEnabled = input.backButtonDidTap.asObservable()
        
        let inquiryButtonEnabled = input.inquiryButtonDidTap.asObservable()
        
        let normalSearchCollectionViewHeight = input.normalSearchCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(resultCount: resultCount.asObservable(),
                      normalSearchList: normalSearchList.asObservable(),
                      backButtonEnabled: backButtonEnabled,
                      inquiryButtonEnabled: inquiryButtonEnabled,
                      normalSearchCollectionViewHeight: normalSearchCollectionViewHeight)
    }
}
