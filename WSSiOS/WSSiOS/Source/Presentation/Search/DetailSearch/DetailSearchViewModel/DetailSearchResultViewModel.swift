//
//  DetailSearchResultViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailSearchResultViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let filteredNovels: DetailSearchNovels
    
    private let popViewController = PublishRelay<Void>()
    private let novelCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let presentDetailSearchModal = PublishRelay<Void>()
    
    private let filteredNovelsData = PublishRelay<DetailSearchNovels>()
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let novelCollectionViewContentSize: Observable<CGSize?>
        let novelResultCellSelected: ControlEvent<IndexPath>
        let searchHeaderViewDidTap: Observable<UITapGestureRecognizer>
        
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let popViewController: Observable<Void>
        let novelCollectionViewHeight: Observable<CGFloat>
        let pushToNovelDetailViewController: Observable<Int>
        let presentDetailSearchModal: Observable<Void>
        
        let filteredNovelsData: Observable<DetailSearchNovels>
    }
    
    init(filteredNovels: DetailSearchNovels) {
        self.filteredNovels = filteredNovels
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.novelCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: self.novelCollectionViewHeight)
            .disposed(by: disposeBag)
        
        input.novelResultCellSelected
            .withLatestFrom(filteredNovelsData) { indexPath, data in
                data.novels[indexPath.row].novelId
            }
            .bind(to: pushToNovelDetailViewController)
            .disposed(by: disposeBag)
        
        input.searchHeaderViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentDetailSearchModal.accept(())
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .do(onNext: {
                self.filteredNovelsData.accept(self.filteredNovels)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(popViewController: popViewController.asObservable(),
                      novelCollectionViewHeight: novelCollectionViewHeight.asObservable(),
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      presentDetailSearchModal: presentDetailSearchModal.asObservable(),
                      filteredNovelsData: filteredNovelsData.asObservable())
    }
}
