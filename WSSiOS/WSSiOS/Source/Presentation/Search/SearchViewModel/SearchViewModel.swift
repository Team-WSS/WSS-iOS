//
//  SearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 2/29/24.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {

    //MARK: - Properties
    
    private let novelRepository: NovelRepository
    
    //MARK: - Inputs
    
    struct Input {
        let backButtonTapped: ControlEvent<Void>
        let searchCellSelected: ControlEvent<IndexPath>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var searchResultList = BehaviorRelay<[SearchNovel]>(value: [])
        
        let backToHome = PublishRelay<Bool>()
        let navigateToRegisterNormal = PublishRelay<IndexPath>()
    }
    
    //MARK: - init
  
    init(novelRepository: NovelRepository) {
        self.novelRepository = novelRepository
    }
}

//MARK: - Methods

extension SearchViewModel {
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        
        input.backButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                output.backToHome.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.searchCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                output.navigateToRegisterNormal.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
