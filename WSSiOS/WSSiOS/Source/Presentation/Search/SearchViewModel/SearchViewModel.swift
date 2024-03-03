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
    private let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    struct Input {
        let searchTextUpdated: ControlProperty<String>
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
    
    //MARK: - API
    
    private func getDataFromAPI(searchWord: String) -> Observable<SearchNovels> {
        novelRepository.getSearchNovels(searchWord: searchWord)
            .observe(on: MainScheduler.instance)
    }
}

//MARK: - Methods

extension SearchViewModel {
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        
        input.searchTextUpdated
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { text in
                if text.isEmpty {
                    return Observable<[SearchNovel]>.empty()
                }
                else {
                    return self.getDataFromAPI(searchWord: text)
                        .map { $0.novels }
                }
            }
            .subscribe( onNext: { novels in
                output.searchResultList.accept(novels)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
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
