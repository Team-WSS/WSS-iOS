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
    
    private let viewWillAppearEvent = BehaviorRelay<Bool>(value: false)
    private let normalSearchList = PublishSubject<[NormalSearchNovel]>()
    private let backButtonEnabled = PublishRelay<Bool>()
    private let inquiryButtonEnabled = PublishRelay<Bool>()
    private let normalSearchCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    //MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Bool>
        let backButtonDidTap: ControlEvent<Void>
        let inquiryButtonDidTap: ControlEvent<Void>
        let normalSearchCollectionViewContentSize: Observable<CGSize?>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let normalSearchList: Observable<[NormalSearchNovel]>
        let backButtonEnabled: Observable<Void>
        let inquiryButtonEnabled: Observable<Void>
        let normalSearchCollectionViewHeight: Driver<CGFloat>
    }
    
    //MARK: - init
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    
    //MARK: - API
    
}

//MARK: - Methods

extension NormalSearchViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.searchRepository.getSearchNovels()
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.normalSearchList.onNext(data)
            }, onError: { owner, error in
                owner.normalSearchList.onError(error)
            })
            .disposed(by: disposeBag)
        
        let backButtonEnabled = input.backButtonDidTap.asObservable()
        
        let inquiryButtonEnabled = input.inquiryButtonDidTap.asObservable()
        
        let normalSearchCollectionViewHeight = input.normalSearchCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(normalSearchList: normalSearchList.asObservable(),
                      backButtonEnabled: backButtonEnabled,
                      inquiryButtonEnabled: inquiryButtonEnabled,
                      normalSearchCollectionViewHeight: normalSearchCollectionViewHeight)
    }
}
