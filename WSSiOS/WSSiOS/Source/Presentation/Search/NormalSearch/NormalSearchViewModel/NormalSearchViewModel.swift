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
    
    //MARK: - Inputs
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let inquiryButtonDidTap: ControlEvent<Void>
        let normalSearchCollectionViewContentSize: Observable<CGSize?>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let normalSearchList = BehaviorRelay<[NormalSearchNovel]>(value: [])
        let backButtonEnabled = PublishRelay<Bool>()
        let inquiryButtonEnabled = PublishRelay<Bool>()
        let normalSearchCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
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
        let output = Output()
        
        searchRepository.getSearchNovels()
            .subscribe(with: self, onNext: { owner, data in
                output.normalSearchList.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: { _ in
                output.backButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.inquiryButtonDidTap
            .subscribe(onNext: { _ in
                output.inquiryButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.normalSearchCollectionViewContentSize
            .map{ $0?.height ?? 0 }
            .bind(to: output.normalSearchCollectionViewHeight)
            .disposed(by: disposeBag)
        
        return output
    }
}
