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
    
    private let isLogined = APIConstants.isLogined
    
    //MARK: - Inputs
    
    struct Input {
        let searhBarDidTap: Observable<UITapGestureRecognizer>
        let induceButtonDidTap: Observable<UITapGestureRecognizer>
        let sosoPickCellSelected: Observable<IndexPath>
        let pushToDetailSearchResultNotification: Observable<Notification>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var sosoPickList = BehaviorRelay<[SosoPickNovel]>(value: [])
        let searchBarEnabled = PublishRelay<Bool>()
        let induceButtonEnabled = PublishRelay<Bool>()
        let navigateToNovelDetailView = PublishRelay<IndexPath>()
        let pushToDetailSearchResultView = PublishRelay<Notification>()
        let presentToInduceLoginView = PublishRelay<Void>()
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
                if self.isLogined {
                    output.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.induceButtonDidTap
            .subscribe(onNext: { _ in
                output.induceButtonEnabled.accept(true)
                if self.isLogined {
                    output.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.sosoPickCellSelected
            .subscribe(onNext: { indexPath in
                output.navigateToNovelDetailView.accept(indexPath)
                if self.isLogined {
                    output.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.pushToDetailSearchResultNotification
            .subscribe(with: self, onNext: { owner, notification in
                output.pushToDetailSearchResultView.accept(notification)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
