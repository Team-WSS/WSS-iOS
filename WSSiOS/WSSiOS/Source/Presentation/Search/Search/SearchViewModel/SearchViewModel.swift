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
    private let isLoggedIn: Bool
    
    private let sosoPickList = BehaviorRelay<[SosoPickNovel]>(value: [])
    private let pushToNormalSearchViewController = PublishRelay<Bool>()
    private let pushToDetailSearchViewController = PublishRelay<Bool>()
    private let pushToNovelDetailViewController = PublishRelay<IndexPath>()
    
    private let pushToLoginViewController = PublishRelay<Void>()
    private let showInduceLoginModalView = PublishRelay<Bool>()
    
    //MARK: - Inputs
    
    struct Input {
        let searhBarDidTap: Observable<UITapGestureRecognizer>
        let induceButtonDidTap: Observable<UITapGestureRecognizer>
        let sosoPickCellSelected: Observable<IndexPath>
        
        let induceModalViewLoginButtonDidtap: ControlEvent<Void>
        let induceModalViewCancelButtonDidtap: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var sosoPickList: Observable<[SosoPickNovel]>
        let pushToNormalSearchViewController: Observable<Bool>
        let pushToDetailSearchViewController: Observable<Bool>
        let pushToNovelDetailViewController: Observable<IndexPath>

        let pushToLoginViewController: Observable<Void>
        let showInduceLoginModalView: Observable<Bool>
    }
    
    //MARK: - init
  
    init(searchRepository: SearchRepository, isLoggedIn: Bool) {
        self.searchRepository = searchRepository
        self.isLoggedIn = isLoggedIn
    }
    
    //MARK: - API
    
}

//MARK: - Methods

extension SearchViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        searchRepository.getSosoPickNovels()
            .subscribe(with: self, onNext: { owner, data in
                owner.sosoPickList.accept(data.sosoPicks)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.searhBarDidTap
            .subscribe(onNext: { _ in
                self.pushToNormalSearchViewController.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.induceButtonDidTap
            .subscribe(onNext: { _ in
                if self.isLoggedIn {
                    self.pushToLoginViewController.accept(())
                } else {
                    self.showInduceLoginModalView.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.sosoPickCellSelected
            .subscribe(onNext: { indexPath in
                if self.isLoggedIn {
                    self.pushToNovelDetailViewController.accept(indexPath)
                } else {
                    self.showInduceLoginModalView.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.induceModalViewLoginButtonDidtap
            .subscribe(with: self, onNext: { owner, _ in
                owner.pushToLoginViewController.accept(())
            })
            .disposed(by: disposeBag)

        input.induceModalViewCancelButtonDidtap
            .subscribe(with: self, onNext: { owner, _ in
                self.showInduceLoginModalView.accept(false)
            })
            .disposed(by: disposeBag)
        
        return Output(sosoPickList: sosoPickList.asObservable(),
                      pushToNormalSearchViewController: pushToNormalSearchViewController.asObservable(),
                      pushToDetailSearchViewController: pushToDetailSearchViewController.asObservable(),
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      pushToLoginViewController: pushToLoginViewController.asObservable(),
                      showInduceLoginModalView: showInduceLoginModalView.asObservable())
    }
}
