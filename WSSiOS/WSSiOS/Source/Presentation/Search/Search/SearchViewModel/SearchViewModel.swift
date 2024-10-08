//
//  SearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 2/29/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class SearchViewModel: ViewModelType {

    //MARK: - Properties
    
    private let searchRepository: SearchRepository
    private let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    struct Input {
        let searhBarDidTap: Observable<UITapGestureRecognizer>
        let induceButtonDidTap: Observable<UITapGestureRecognizer>
        let sosoPickCellSelected: Observable<IndexPath>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var sosoPickList = BehaviorRelay<[SosoPickNovel]>(value: [])
        let searchBarEnabled = PublishRelay<Bool>()
        let induceButtonEnabled = PublishRelay<Bool>()
        let navigateToNovelDetailView = PublishRelay<IndexPath>()
    }
    
    //MARK: - init
  
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    //MARK: - API
    
}

//MARK: - Methods

extension SearchViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        searchRepository.getSosoPickNovels()
            .subscribe(with: self, onNext: { owner, data in
                output.sosoPickList.accept(data.sosoPicks)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.searhBarDidTap
            .subscribe(onNext: { _ in
                output.searchBarEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.induceButtonDidTap
            .subscribe(onNext: { _ in
                output.induceButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.sosoPickCellSelected
            .subscribe(onNext: { indexPath in
                output.navigateToNovelDetailView.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
