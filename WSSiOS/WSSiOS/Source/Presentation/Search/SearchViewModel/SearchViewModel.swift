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
    
    private let searchRepository: SearchRepository
    private let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    struct Input {
        
    }
    
    //MARK: - Outputs
    
    struct Output {
        var sosoPickList = BehaviorRelay<[SosoPickNovel]>(value: [])
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
                output.sosoPickList.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
