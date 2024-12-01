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
        let pushToNormalSearchViewController = PublishRelay<Void>()
        let pushToDetailSearchViewController = PublishRelay<Void>()
        let pushToNovelDetailViewController = PublishRelay<Int>()
        let pushToDetailSearchResultView = PublishRelay<Notification>()
        let presentToInduceLoginView = PublishRelay<Void>()
        let showLoadingView = PublishRelay<Bool>()
    }
    
    //MARK: - init
  
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    //MARK: - API
    
    func getSosoPickNovels() -> Observable<SosoPickNovels> {
        return searchRepository.getSosoPickNovels()
    }
}

//MARK: - Methods

extension SearchViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.getSosoPickNovels()
            .do(onNext: { _ in
                output.showLoadingView.accept(true)
            })
            .subscribe(with: self, onNext: { owner, data in
                output.sosoPickList.accept(data.sosoPicks)
                output.showLoadingView.accept(false)
            }, onError: { owner, error in
                print(error)
                output.showLoadingView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.searhBarDidTap
            .subscribe(onNext: { _ in
                if self.isLogined {
                    output.pushToNormalSearchViewController.accept(())
                } else {
                    output.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.induceButtonDidTap
            .subscribe(onNext: { _ in
                if self.isLogined {
                    output.pushToDetailSearchViewController.accept(())
                } else {
                    output.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.sosoPickCellSelected
            .subscribe(onNext: { indexPath in
                if self.isLogined {
                    let novelId = output.sosoPickList.value[indexPath.row].novelId
                    output.pushToNovelDetailViewController.accept(novelId)
                } else {
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
