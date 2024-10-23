//
//  DetailSearchResultViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import Foundation

import RxSwift
import RxCocoa

final class DetailSearchResultViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let detailSearchNovels: DetailSearchNovels
    
    private let popViewController = PublishRelay<Void>()
    private let novelCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let novelCollectionViewContentSize: Observable<CGSize?>
    }
    
    struct Output {
        let popViewController: Observable<Void>
        let novelCollectionViewHeight: Observable<CGFloat>
    }
    
    init(detailSearchNovels: DetailSearchNovels) {
        self.detailSearchNovels = detailSearchNovels
    }
    
    func getNovelsObservable() -> Observable<[SearchNovel]> {
        return Observable.just(detailSearchNovels.novels)
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
        
        return Output(popViewController: popViewController.asObservable(),
        novelCollectionViewHeight: novelCollectionViewHeight.asObservable())
    }
}
